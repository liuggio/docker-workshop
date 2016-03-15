<?php

class Service {
    private $host;
    private $class;
    private $ttl;
    private $type;
    private $pri;
    private $weight;
    private $port;
    private $target;

    /**
     * Service constructor.
     * @param $host
     * @param $class
     * @param $ttl
     * @param $type
     * @param $pri
     * @param $weight
     * @param $port
     * @param $target
     */
    public function __construct($host, $class, $ttl, $type, $pri, $weight, $port, $target)
    {
        $this->host = $host;
        $this->class = $class;
        $this->ttl = $ttl;
        $this->type = $type;
        $this->pri = $pri;
        $this->weight = $weight;
        $this->port = $port;
        $this->target = $target;
    }

    /**
     * Factory method.
     *
     * @param $result
     * @return Service
     */
    public static function createFromArray($result)
    {
        return new self(
            $result["host"],
            $result["class"],
            $result["ttl"],
            $result["type"],
            $result["pri"],
            $result["weight"],
            $result["port"],
            $result["target"]
        );
    }


    /**
     * @return mixed
     */
    public function getHost()
    {
        return $this->host;
    }

    /**
     * @return mixed
     */
    public function getClass()
    {
        return $this->class;
    }

    /**
     * @return mixed
     */
    public function getTtl()
    {
        return $this->ttl;
    }

    /**
     * @return mixed
     */
    public function getType()
    {
        return $this->type;
    }

    /**
     * @return mixed
     */
    public function getPri()
    {
        return $this->pri;
    }

    /**
     * @return mixed
     */
    public function getWeight()
    {
        return $this->weight;
    }

    /**
     * @return mixed
     */
    public function getPort()
    {
        return $this->port;
    }

    /**
     * @return mixed
     */
    public function getTarget()
    {
        return $this->target;
    }

    public function __toString()
    {
        return sprintf("%s:%s", $this->host, $this->port);
    }
}

function getRandomResult($results) {
    return array_rand($results,1);
}

function getFirst($results) {
    return $results[0];
}

function getDnsService($name, $suffix="service.consul.", callable $strategy = null) {

    $strategy = $strategy?:getFirst;
    $results=dns_get_record(sprintf("%s.%s",$name,$suffix), DNS_SRV);

    if (!$results || count($results)<=0) {
        throw new \Exception("Impossible to connect to dns service");
    }

    return Service::createFromArray($strategy($results));
}