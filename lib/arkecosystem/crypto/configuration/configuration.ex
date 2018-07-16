defmodule ArkEcosystem.Crypto.Configuration.Configuration do
  use KVX.Bucket

  def get_value(key, bucket \\ :ark_config) do
    bucket = new(bucket)
    get(bucket, key)
  end

  def set_value(key, value, bucket \\ :ark_config) do
    bucket = new(bucket)
    set(bucket, key, value)
    get_value(key, bucket)
  end
end
