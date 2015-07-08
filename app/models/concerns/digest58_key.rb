module Digest58Key
  def self.included(base)
    base.class_eval do
      before_create do
        write_attribute(:key, Base58.key_digest58) if key.nil?
      end
    end
  end
end
