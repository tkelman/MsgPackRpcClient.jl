#!/usr/bin/env julia

include("../src/MsgPackRpcClient.jl")
include("dataset.jl")
using MsgPackRpcClient
using Base.Test

i = 1
hostname = "localhost"
port = 5000

function test_data(data, number = 1)
  for d in data
    println("$(number): $d ")
    #try
      if haskey(d, "arg4")
        result = MsgPackRpcClient.call(session, d["method"], d["arg1"], d["arg2"], d["arg3"], d["arg4"]; sync = true)
      elseif haskey(d, "arg3")
        result = MsgPackRpcClient.call(session, d["method"], d["arg1"], d["arg2"], d["arg3"]; sync = true)
      elseif haskey(d, "arg2")
        result = MsgPackRpcClient.call(session, d["method"], d["arg1"], d["arg2"]; sync = true)
      elseif haskey(d, "arg1")
        result = MsgPackRpcClient.call(session, d["method"], d["arg1"]; sync = true)
      else
        error
      end
      println("result = ", result)
      println("first(result) = ", first(result))
      if haskey(d, "expect")
        @test first(result) == d["expect"]
      else
        #@test first(result) == d["arg"]
      end
      println("  => OK")
    #catch
    #  #println("Error on d[\"arg\"] = ", d["arg"])
    #  println("Error")
    #end
    number += 1
  end
end

session = MsgPackRpcClientSession.create()

test_data(get_dataset_for_arguments())

session.destroy()
