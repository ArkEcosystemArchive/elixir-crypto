defmodule ArkEcosystem.Crypto.MessageTest do
  use ExUnit.Case, async: false
  alias ArkEcosystem.Crypto.Message

  test "should be able to sign a message" do
    signed = Message.sign("hello", "world")
    assert(signed[:message] == "hello")
    assert(signed[:publickey] == "039b101edcbe1ee37ff6b2318526a425b629e823d7d8d9154417880595a28000ee")
    assert(signed[:signature] == "3045022100ff2007e57064946fb80f4280dca2a9d312c8ec9a101f706700eae732947b65f302207a6a0fbd07d4084aba6dcd53d0c3ef531bd42d0281079323709ac2026420a8a7")
  end

  test "should be able to verify a message" do
    signed = Message.sign("hello", "world")
    assert(Message.verify(signed[:message], signed[:signature], signed[:publickey]) == true)
    # Change last character of signature, as verify should then return false 
    assert(Message.verify(signed[:message], "3045022100ff2007e57064946fb80f4280dca2a9d312c8ec9a101f706700eae732947b65f302207a6a0fbd07d4084aba6dcd53d0c3ef531bd42d0281079323709ac2026420a8a2", signed[:publickey]) == false)
  end

end
