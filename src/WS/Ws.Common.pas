unit Ws.Common;

interface

type

  TWSHTTPMethodType = (httpGET, httpPOST, httpPUT, httpDELETE, httpHEAD,
    httpOPTIONS, httpPATCH, httpTRACE);

  TWSHTTPCode = record
  public const
    // Respostas de informação (100-199),
    WS_HTTP_CODE_CONTINUE = 100;

    // Respostas de sucesso (200-299),
    WS_HTTP_CODE_OK = 200;
    WS_HTTP_CODE_CREATED = 201;
    WS_HTTP_CODE_ACCEPTED = 202;
    WS_HTTP_CODE_NON_AUTHORITATIVE_INFO = 203;
    WS_HTTP_CODE_NO_CONTENT = 204;
    WS_HTTP_CODE_RESET_CONTENT = 205;
    WS_HTTP_CODE_PARTIAL_CONTENT = 206;

    // Redirecionamentos (300-399)
    WS_HTTP_CODE_MULTIPLE_CHOICE = 300;
    WS_HTTP_CODE_MOVED_PERMANENTLY = 301;
    WS_HTTP_CODE_FOUND = 302;
    WS_HTTP_CODE_SEE_OTHER = 303;
    WS_HTTP_CODE_NOT_MODIFIED = 304;
    WS_HTTP_CODE_TEMPORARY_REDIRECT = 307;
    WS_HTTP_CODE_PERMANENT_REDIRECT = 308;

    // Erros do cliente (400-499)
    WS_HTTP_CODE_BAD_REQUEST = 400;
    WS_HTTP_CODE_UNAUTHORIZED = 401;
    WS_HTTP_CODE_PAYMENT_REQUIRED = 402;
    WS_HTTP_CODE_FORBIDDEN = 403;
    WS_HTTP_CODE__NOT_FOUND = 404;
    WS_HTTP_CODE_METHOD_NOT_ALLOWED = 405;
    WS_HTTP_CODE_NOT_ACCEPTABLE = 406;

    // Erros do servidor (500-599)
    WS_HTTP_CODE_INTERNAL_SERVER_ERROR = 500;
    WS_HTTP_CODE_NOT_IMPLEMENTED = 501;
    WS_HTTP_CODE_BAD_GATEWAY = 502;
    WS_HTTP_CODE_SERVICE_UNAVAILABLE = 503;
    WS_HTTP_CODE_GATEWAY_TIMEOUT = 504;
    WS_HTTP_CODE_HTTP_VERSION_NOT_SUPPORTED = 505;
  end;

  TWSMediaType = record
  public const
    APPLICATION_ATOM_XML = 'application/atom+xml';
    APPLICATION_JSON = 'application/json';
    APPLICATION_OCTET_STREAM = 'application/octet-stream';
    APPLICATION_SVG_XML = 'application/svg+xml';
    APPLICATION_XHTML_XML = 'application/xhtml+xml';
    APPLICATION_XML = 'application/xml';
    APPLICATION_OCTETSTREAM = 'application/octet-stream';
    MEDIA_TYPE_WILDCARD = '*';
    MULTIPART_FORM_DATA = 'multipart/form-data';
    APPLICATION_FORM_URLENCODED = 'application/x-www-form-urlencoded';
    TEXT_HTML = 'text/html';
    TEXT_PLAIN = 'text/plain';
    TEXT_XML = 'text/xml';
    TEXT_CSS = 'text/css';
    TEXT_JAVASCRIPT = 'text/javascript';
    TEXT_CACHEMANIFEST = 'text/cache-manifest';
    TEXT_EVENTSTREAM = 'text/event-stream';
    TEXT_CSV = 'text/csv';
    IMAGE_JPEG = 'image/jpeg';
    IMAGE_X_PNG = 'image/x-png';
    IMAGE_X_ICON = 'image/x-icon';
    IMAGE_PNG = 'image/png';
    IMAGE_SVG_XML = 'image/svg+xml';
    IMAGE_GIF = 'image/gif';
    APPLICATION_PDF = 'application/pdf';
    APPLICATION_X_PDF = 'application/x-pdf';
    WILDCARD = '*/*';
  end;

implementation

end.
