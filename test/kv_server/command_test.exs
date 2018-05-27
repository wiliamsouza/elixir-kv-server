defmodule KVServer.CommandTest do
  use ExUnit.Case, async: true
  doctest KVServer.Command

  test "run command create" do
    assert KVServer.Command.run({:create, "shopping"}, KV.Registry) == {:ok, "OK\r\n"}
  end

  test "run command get" do
    KV.Registry.create(KV.Registry, "todolist")
    {:ok, bucket} = KV.Registry.lookup(KV.Registry, "todolist")
     KV.Bucket.put(bucket, "learn", "elixir")
    assert KV.Bucket.get(bucket, "learn") == "elixir"

    assert KVServer.Command.run({:get, "todolist", "learn"}, KV.Registry) == {:ok, "elixir\r\nOK\r\n"}
  end

  test "run command put" do
    KV.Registry.create(KV.Registry, "todolist")
    {:ok, bucket} = KV.Registry.lookup(KV.Registry, "todolist")

    assert KVServer.Command.run({:put, "todolist", "learn", "erlang"}, KV.Registry) == {:ok, "OK\r\n"}

    assert KV.Bucket.get(bucket, "learn") == "erlang"
  end

  test "run command delete" do
    KV.Registry.create(KV.Registry, "todolist")
    {:ok, bucket} = KV.Registry.lookup(KV.Registry, "todolist")
    KV.Bucket.put(bucket, "learn", "java")
    assert KV.Bucket.get(bucket, "learn") == "java"

    assert KVServer.Command.run({:delete, "todolist", "learn"}, KV.Registry) == {:ok, "OK\r\n"}

    assert KV.Bucket.get(bucket, "learn") == nil
  end
end
