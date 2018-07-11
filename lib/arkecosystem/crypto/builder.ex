defmodule ArkEcosystem.Crypto.Builder do
  alias ArkEcosystem.Crypto.Crypto
  alias ArkEcosystem.Crypto.Slot
  alias ArkEcosystem.Crypto.Enums.Types
  alias ArkEcosystem.Crypto.Configuration.{Fee}
  alias ArkEcosystem.Crypto.Utils.{EcKey}

  @transfer Types.transfer()
  @second_signature_registration Types.second_signature_registration()
  @delegate_registration Types.delegate_registration()
  @vote Types.vote()
  @multi_signature_registration Types.multi_signature_registration()
  @ipfs Types.ipfs()
  @timelock_transfer Types.timelock_transfer()
  @multi_payment Types.multi_payment()
  @delegate_resignation Types.delegate_resignation()

  def build_transfer(recipient_id, amount, vendor_field, secret, second_secret \\ nil) do
    transfer = %{
      :type => @transfer,
      :fee => Fee.get(@transfer),
      :recipient_id => recipient_id,
      :amount => amount,
      :vendor_field => vendor_field,
      :asset => %{}
    }

    transaction_skeleton()
      |> Map.merge(transfer)
      |> Crypto.sign_transaction(secret, second_secret)
  end

  def build_vote(votes, secret, second_secret \\ nil) do
    vote = %{
      :type => @vote,
      :fee => Fee.get(@vote),
      :recipient_id => EcKey.secret_to_address(secret),
      :asset => %{
        :votes => votes
      }
    }

    transaction_skeleton()
      |> Map.merge(vote)
      |> Crypto.sign_transaction(secret, second_secret)
  end

  def build_second_signature_registration(secret, second_secret \\ nil) do
    second_signature_registration = %{
      :type => @second_signature_registration,
      :fee => Fee.get(@second_signature_registration),
      :asset => %{
        :signature => %{
          :public_key => EcKey.secret_to_public_key(secret)
        }
      }
    }

    transaction_skeleton()
      |> Map.merge(second_signature_registration)
      |> Crypto.sign_transaction(secret, second_secret)
  end

  def build_delegate_registration(username, secret, second_secret \\ nil) do
    delegate_registration = %{
      :type => @delegate_registration,
      :fee => Fee.get(@delegate_registration),
      :asset => %{
        :delegate => %{
          :username => username,
          :public_key => EcKey.secret_to_public_key(secret)
        }
      }
    }

    transaction_skeleton()
      |> Map.merge(delegate_registration)
      |> Crypto.sign_transaction(secret, second_secret)
  end

  def build_multi_signature_registration(min, lifetime, keysgroup, secret, second_secret \\ nil) do
    keys_count = length keysgroup
    multi_signature_registration = %{
      :type => @multi_signature_registration,
      :fee => (keys_count + 1) * Fee.get(@multi_signature_registration),
      :asset => %{
        :multisignature => %{
          :min => min,
          :lifetime => lifetime,
          :keysgroup => keysgroup
        }
      }
    }

    transaction_skeleton()
      |> Map.merge(multi_signature_registration)
      |> Crypto.sign_transaction(secret, second_secret)
  end

  def build_ipfs do
    # TODO: implement
    @ipfs
  end

  def build_timelock_transfer do
    # TODO: implement
    @timelock_transfer
  end

  def build_multi_payment do
    # TODO: implement
    @multi_payment
  end

  def build_delegate_resignation do
    # TODO: implement
    @delegate_resignation
  end


  #### Private

  defp transaction_skeleton do
    %{
      :id => nil,
      :amount => 0,
      :timestamp => Slot.get_time
    }
  end

end

