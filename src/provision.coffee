# ping = require 'ping'
tcpp = require 'tcp-ping'
tcp_hosts = ['rabbitmq']
# http_hosts = ['rethinkdb']
max_tries = 20
count = 1
_check = (connected, host, cb)->
  if connected
    console.log "Connected to #{host.toUpperCase()} on try", count
    count = 1
    Promise.resolve()
  else if count <= max_tries
    count++
    setTimeout cb, 500, host
  else
    console.log 'Connection attempts failed for', host
    count = 1
    Promise.reject()

tcp_port = null
_tcp_connect = (host)->
  new Promise (resolve, reject)->
    port = tcp_port || 5672
    opts =
      address: host
      port: port
    tcpp.ping opts, (err, data)->
      if err
        console.log 'Unhandled error', err
        reject()
      else
        recheck = false
        _count = 1
        logged = false
        for result in data.results
          if result.err
            if result.err.code is 'ECONNREFUSED'
              if !logged and (count % 5) is 0
                logged = true
                console.log "Connection to #{host}:#{port} refused on #{count}"
              recheck = true
            else
              reject result.err
        if recheck
          _check false, host, _tcp_connect
        else
          _check true, host, null

_http_port = null
_http_connect = (host)->
  ping.sys.probe host, (err, isAlive)->
    if err
      dfd.reject err
    else
      _check isAlive, host, _http_connect


promises = []
if process.env.TCP_HOSTS then tcp_hosts = process.env.TCP_HOSTS.split ','
console.log tcp_hosts
for tcp_host in tcp_hosts
  if tcp_host.port then tcp_port = tcp_host.port
  promises.push _tcp_connect tcp_host
# if process.env.HTTP_HOSTS then http_hosts = process.env.HTTP_HOSTS.split ','
# console.log http_hosts
# for http_host in http_hosts
#   if http_host.port then http_port = http_host.port
#   promises.push _http_connect http_host

Promise.all promises
.then ->
  console.log """
  Connected to hosts:
  TCP: #{tcp_hosts}
  """
