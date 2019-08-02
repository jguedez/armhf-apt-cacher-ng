# armhf-apt-cacher-ng

Caching of apt repositories for Raspberry pi

Project page: https://wiki.debian.org/AptCacherNg

## Usage
* repo includes an example docker compose file
* or just run the container like this:

```
docker run -d -p 3142:3142 --name aptcache jguedez/apt-cacher-ng
```

On the **client**, create a apt config file as follows (use relevant **hostname**)

```
echo 'Acquire::http { Proxy "http://aptcache:3142"; };' >> /etc/apt/apt.conf.d/01proxy
```
