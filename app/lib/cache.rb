class Cache
  EXPIRE_IN = 5.minutes

  class << self
    def set(key, value, expired_at: default_expired_at)
      key = key.to_s
      store[key] = [ value, expired_at ]
    end

    def get(key)
      key = key.to_s

      if store[key]
        store[key][1] > Time.now ? store[key][0] : nil
      end
    end

    def store
      @@store ||= Hash.new
    end

    def default_expired_at
      Time.now + EXPIRE_IN
    end
  end
end