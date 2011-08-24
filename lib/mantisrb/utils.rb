require 'openssl'

module Mantis

  module Blowfish
    def self.cipher(mode, key, data)
      cipher = OpenSSL::Cipher::Cipher.new('bf-cbc').send(mode)
      cipher.key = Digest::SHA256.digest(key)
      cipher.update(data) << cipher.final
    end

    def self.encrypt(key, data)
      cipher(:encrypt, key, data)
    end

    def self.decrypt(key, text)
      cipher(:decrypt, key, text)
    end
  end
end
