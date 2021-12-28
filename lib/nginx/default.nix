{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nginx;

  nextConfigureFlags = {
    error-log-path = "/usr/local/var/log/nginx/error.log";
    http-log-path = "/usr/local/var/log/nginx/access.log";
    http-client-body-temp-path = "/usr/local/var/cache/nginx/client_body";
    pid-path = "/usr/local/var/log/nginx/nginx.pid";
    http-proxy-temp-path = "/usr/local/var/cache/nginx/proxy";
    http-fastcgi-temp-path = "/usr/local/var/cache/nginx/fastcgi";
    http-uwsgi-temp-path = "/usr/local/var/cache/nginx/uwsgi";
    http-scgi-temp-path = "/usr/local/var/cache/nginx/scgi";
  };

  nginxPkg = cfg.package.overrideAttrs (prev:
    let
      removeFlags = lib.mapAttrsToList (name: _: "--${name}") nextConfigureFlags;
    in
    {
      configureFlags = (lib.filter
        (flag: !lib.any (prefix: lib.strings.hasPrefix prefix flag) removeFlags)
        prev.configureFlags) ++ lib.mapAttrsToList (name: value: "--${name}=${value}") nextConfigureFlags;
    });

  configFile = pkgs.writers.writeNginxConfig "nginx.conf" ''
    error_log stderr;
    daemon off;
    worker_processes auto;
    user nginx nginx;

    events {
      worker_connections 1024;
    }

    http {
        include       ${nginxPkg}/conf/mime.types;
        default_type  application/octet-stream;

        sendfile        on;

        keepalive_timeout  65;
        proxy_read_timeout 1800000;
        proxy_connect_timeout 1800000;
        proxy_send_timeout 1800000;
        send_timeout 1800000;

        gzip  on;

        include ${cfg.includePath}/*.conf;
    }
  '';
in
{
  options = {
    services.nginx = {
      package = mkOption {
        type = types.either types.package types.path;
        default = pkgs.nginxMainline;
        defaultText = "pkgs.nginxMainline";
        example = literalExpression "pkgs.nginxUnstable";
        description = ''
          Nginx package
        '';
      };
      includePath = mkOption {
        type = types.str;
        default = "/tmp";
        example = "/Users/user/nginx";
        description = "Include config files from this folder";
      };
    };
  };
  config = {
    launchd.daemons.nginx = {
      path = with pkgs; [ coreutils nginxPkg ];
      script = ''
        mkdir -p /usr/local/var/log/nginx /usr/local/var/cache/nginx
        ${nginxPkg}/bin/nginx -c ${configFile}
      '';
      serviceConfig = {
        RunAtLoad = true;
        KeepAlive = true;
      };
    };

    users.knownUsers = [ "nginx" ];
    users.knownGroups = [ "nginx" ];

    users.users = {
      nginx = {
        gid = 42000;
        uid = 42000;
      };
    };

    users.groups = {
      nginx.gid = 42000;
    };
  };
}
