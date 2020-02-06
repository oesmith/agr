require "base64"
require "openssl"

module ImageProxyHelper
  def proxy_image(url)
    sig = Base64.urlsafe_encode64(
      OpenSSL::HMAC.digest(
        OpenSSL::Digest.new("sha256"), "ahtah5WaeCheikiphai6Kahf2Coh3jei", url
      )
    ).strip()
    "https://olly.xyz/i/s#{sig}/#{url}"
  end
end
