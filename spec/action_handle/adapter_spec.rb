describe 'Built-in Adapters' do
  shared_examples :conforms_to_adapter_interface do
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

        expect(instance.info('key')).to eq('value1')
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

    describe '#info' do
      before { instance.create('key', 'value1', 100) }

      it 'returns nil on missing key' do
        expect(instance.info('no_such_key')).to be_nil
      end

      it 'returns handle info on existing key' do
        expect(instance.info('key')).to eq('value1')
      end
    end
  end

  describe ActionHandle::Adapters::RedisPool do
    include_examples :conforms_to_adapter_interface
  end

  describe ActionHandle::Adapters::CacheStore do
    include_examples :conforms_to_adapter_interface

    let(:adapter_args) { ActiveSupport::Cache::RedisCacheStore.new }
  end
end
