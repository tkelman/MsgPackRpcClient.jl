module client

type Client
  address::String
  timeout::Int
  loop::Bool
  builder::String
  reconnect_limit::Int
  pack_encoding::String
  unpack_encoding::String

  function Client(address, timeout, loop, builder, reconnect_limit, pack_encoding, unpack_encoding)
    this = new()
    this.address = address
    this.timeout = timeout
    this.loop = loop
    this.builder = builder
    this.reconnect_limit = reconnect_limit
    this.pack_encoding = pack_encoding
    this.unpack_encoding = unpack_encoding
    this
  end

  function init(self::Client)
  end

  function open(args)
    client = Client(args)
    return Client.Context(client)
  end

  type Context(object)
    client::Client

    function init(self::Context, client::Client)
      self._client = client
    end

    function enter(self::Context)
      return self._client
    end

    function exit(self::Context, _type::String, value::String, traceback::String)
      self.client.close()
      if _type
        return false
      end
      return true
    end

  end
end

# const PORT = 5000

# function connect()
#   connect(PORT)
# end

# function send()
#   return sendv()
# end

# function sendv()

# end

end #client
