describe 'Built-in Adapters' do
  shared_context :conforms_to_adapter_interface do
    let(:klass) { described_class }
    let(:adapter_args) { nil }
    let(:instance) { klass.new(*adapter_args) }

    it 'creates adapter instance' do
      expect { instance }.not_to raise_error
    end

    describe '#create' do
      it 'creates only first, returns false on second' do
        expect(instance.create('key', 'value1', 100)).to eq(true)
        expect(instance.create('key', 'value2', 100)).to eq(false)

        expect(instance.value('key')).to eq('value1')
      end
    end

    describe '#expire' do
      context 'when key exists' do
        before { instance.create('key', 'value1', 100) }

        it { expect(instance.expire('key')).to eq(true) }
      end

      context 'when key does not exist' do
        it { expect(instance.expire('no_such_key')).to eq(false) }
      end
    end

    describe '#current?' do
      before { instance.create('key', 'value1', 100) }

      context 'when key/value matches' do
        it { expect(instance.current?('key', 'value1')).to eq(true) }
      end

      context 'when value does not match' do
        it { expect(instance.current?('key', 'different value')).to eq(false) }
      end

      context 'when key does not match' do
        it { expect(instance.current?('no_such_key', 'value1')).to eq(false) }
      end
    end

    describe '#renew' do
      before { instance.create('key', 'value1', 100) }

      context 'when key/value matches' do
        it { expect(instance.renew('key', 'value1', 200)).to eq(true) }
      end

      context 'when value does not match' do
        it { expect(instance.renew('key', 'value?', 100)).to eq(false) }
      end

      context 'when key does not match' do
        it { expect(instance.renew('no_such_key', 'value1', 100)).to eq(false) }
      end
    end

    describe '#claim' do
      before { instance.create('key', 'value1', 100) }

      context 'when key/value matches' do
        it 'replaces handle' do
          expect(instance.claim('key', 'value1', 100)).to eq(true)
          expect(instance.value('key')).to eq('value1')
        end
      end

      context 'when value does not match' do
        it 'replaces handle' do
          expect(instance.claim('key', 'value?', 100)).to eq(true)
          expect(instance.value('key')).to eq('value?')
        end
      end

      context 'when key does not exist' do
        it 'creates handle' do
          expect(instance.claim('no_such_key', 'value1', 100)).to eq(true)
          expect(instance.value('no_such_key')).to eq('value1')
        end
      end
    end

    describe '#taken?' do
      context 'when key exists' do
        before { instance.create('key', 'value1', 100) }

        it { expect(instance.taken?('key')).to eq(true) }
      end

      context 'when key does not exist' do
        it { expect(instance.taken?('no_such_key')).to eq(false) }
      end
    end

    describe '#value' do
      before { instance.create('key', 'value1', 100) }

      it 'returns nil on missing key' do
        expect(instance.value('no_such_key')).to be_nil
      end

      it 'returns handle value on existing key' do
        expect(instance.value('key')).to eq('value1')
      end
    end
  end

  describe ActionHandle::Adapters::RedisPool do
    include_context :conforms_to_adapter_interface
  end

  describe ActionHandle::Adapters::CacheStore do
    include_context :conforms_to_adapter_interface

    let(:adapter_args) { ActiveSupport::Cache::RedisCacheStore.new }
  end
end
