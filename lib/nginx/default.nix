{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.nginx;

  configFile = pkgs.writers.writeNginxConfig "nginx.conf" ''
    pid /run/nginx/nginx.pid;
    error_log stderr;
    daemon off;
    worker_processes auto;

    events {
      worker_connections 1024;
    }

    http {
        include       ${cfg.package}/conf/mime.types;
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
    nginx = {
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
      path = with pkgs; [ coreutils cfg.package ];
      script = ''
        mkdir -p /var/log/nginx /var/cache/nginx /run/nginx
        ${cfg.package}/bin/nginx -c ${configFile} -p /tmp
      '';
      serviceConfig = {
        RunAtLoad = true;
        KeepAlive = true;
      };
    };
  };
}
