defmodule ArkEcosystem.Crypto.Transactions.Builder do
  alias ArkEcosystem.Crypto.Configuration.Fee
  alias ArkEcosystem.Crypto.Enums.Types
  alias ArkEcosystem.Crypto.Identities.{Address, PublicKey}
  alias ArkEcosystem.Crypto.Transactions.Transaction
  alias ArkEcosystem.Crypto.Utils.Slot

  @transfer Types.transfer()
  @second_signature_registration Types.second_signature_registration()
  @delegate_registration Types.delegate_registration()
  @vote Types.vote()
  @multi_signature_registration Types.multi_signature_registration()
  @ipfs Types.ipfs()
  @timelock_transfer Types.timelock_transfer()
  @multi_payment Types.multi_payment()
  @delegate_resignation Types.delegate_resignation()

  def build_transfer(recipient_id, amount, vendor_field, passphrase, second_passphrase \\ nil) do
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
    |> Transaction.sign_transaction(passphrase, second_passphrase)
  end

  def build_vote(votes, passphrase, second_passphrase \\ nil) do
    vote = %{
      :type => @vote,
      :fee => Fee.get(@vote),
      :recipient_id => Address.from_passphrase(passphrase),
      :asset => %{
        :votes => votes
      }
    }

    transaction_skeleton()
    |> Map.merge(vote)
    |> Transaction.sign_transaction(passphrase, second_passphrase)
  end

  def build_second_signature_registration(passphrase, second_passphrase \\ nil) do
    second_signature_registration = %{
      :type => @second_signature_registration,
      :fee => Fee.get(@second_signature_registration),
      :asset => %{
        :signature => %{
          :public_key => PublicKey.from_passphrase(passphrase)
        }
      }
    }

    transaction_skeleton()
    |> Map.merge(second_signature_registration)
    |> Transaction.sign_transaction(passphrase, second_passphrase)
  end

  def build_delegate_registration(username, passphrase, second_passphrase \\ nil) do
    delegate_registration = %{
      :type => @delegate_registration,
      :fee => Fee.get(@delegate_registration),
      :asset => %{
        :delegate => %{
          :username => username,
          :public_key => PublicKey.from_passphrase(passphrase)
        }
      }
    }

    transaction_skeleton()
    |> Map.merge(delegate_registration)
    |> Transaction.sign_transaction(passphrase, second_passphrase)
  end

  def build_multi_signature_registration(min, lifetime, keysgroup, passphrase, second_passphrase \\ nil) do
    keys_count = length(keysgroup)

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
    |> Transaction.sign_transaction(passphrase, second_passphrase)
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
      :timestamp => Slot.get_time()
    }
  end
end
