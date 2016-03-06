vcl 4.0;

backend default {
  .host = "nexus";
  .port = "8081";
  .connect_timeout = 3s;
  .first_byte_timeout = 60s;
  .between_bytes_timeout = 2s;
}
