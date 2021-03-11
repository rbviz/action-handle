describe ActionHandle::Configuration do
  describe 'ActionHandle.configure' do
    shared_examples :attribute_flow do |key, set_value, get_value|
      subject do
        ActionHandle.configure do |config|
          config.public_send(key, set_value)
        end
      end

      it "returns #{get_value}" do
        expect { subject }.not_to raise_error

        is_expected.to eq(get_value)

        expect(described_class).to have_attributes(key => get_value)
      end
    end

    describe '.silence_errors' do
      before { described_class.silence_errors = nil }

      context 'when set as `false`' do
        include_examples :attribute_flow, :silence_errors, false, false
      end

      context 'when set as `true`' do
        include_examples :attribute_flow, :silence_errors, true, true
      end

      context 'when set as `nil` or unset' do
        include_examples :attribute_flow, :silence_errors, nil, false
      end
    end

    describe '.adapter' do
      before { described_class.adapter = nil }

      context 'when set as `:rails_cache`' do
        include_examples :attribute_flow, :adapter, :rails_cache, :rails_cache
      end

      context 'when set as `:redis_pool`' do
        include_examples :attribute_flow, :adapter, :redis, :redis
      end

      context 'when set as `nil` or unset' do
        include_examples :attribute_flow, :adapter, nil, :redis
      end

      context 'when set as custom class' do
        include_examples(
          :attribute_flow,
          :adapter,
          *[Struct.new(:to_s).new('custom class')] * 2
        )
      end
    end
  end
end
