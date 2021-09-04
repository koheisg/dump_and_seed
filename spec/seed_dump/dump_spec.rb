require 'spec_helper'

RSpec.describe SeedDump::Dump do
  describe '.dump' do
    subject { described_class.dump }

    before do
      Rails.application.eager_load!
      create_db
      FactoryBot.create_list(:sample, 3) do |sample|
        FactoryBot.create(:another_sample, sample_id: sample.id)
      end
    end

    specify :aggregate_failures do
      expect { subject }.to change { File.exist?('tmp/db/seeds.rb') }
      expect(File.read('tmp/db/seeds.rb')).to eq(<<~RUBY)
        # frozen_string_literal: true

        load(Rails.root.join('db','seeds','samples.rb'))
        load(Rails.root.join('db','seeds','yet_another_samples.rb'))
        load(Rails.root.join('db','seeds','empty_models.rb'))
        load(Rails.root.join('db','seeds','another_samples.rb'))
      RUBY
      expect(File.read('tmp/db/seeds/samples.rb')).to eq(<<~RUBY)
        # frozen_string_literal: true

        Sample.insert_all!([
          {id: 1, string: "string", text: "text", integer: 42, float: 3.14, decimal: 0.272e1, datetime: "1776-07-04 19:14:00.000000000 +0000", time: "2000-01-01 03:15:00.000000000 +0000", date: "1863-11-19", binary: "binary", boolean: false, created_at: "1969-07-20 20:18:00.000000000 +0000", updated_at: "1989-11-10 04:20:00.000000000 +0000"},
          {id: 2, string: "string", text: "text", integer: 42, float: 3.14, decimal: 0.272e1, datetime: "1776-07-04 19:14:00.000000000 +0000", time: "2000-01-01 03:15:00.000000000 +0000", date: "1863-11-19", binary: "binary", boolean: false, created_at: "1969-07-20 20:18:00.000000000 +0000", updated_at: "1989-11-10 04:20:00.000000000 +0000"},
          {id: 3, string: "string", text: "text", integer: 42, float: 3.14, decimal: 0.272e1, datetime: "1776-07-04 19:14:00.000000000 +0000", time: "2000-01-01 03:15:00.000000000 +0000", date: "1863-11-19", binary: "binary", boolean: false, created_at: "1969-07-20 20:18:00.000000000 +0000", updated_at: "1989-11-10 04:20:00.000000000 +0000"},
        ])
      RUBY
      expect(File.read('tmp/db/seeds/another_samples.rb')).to eq(<<~RUBY)
        # frozen_string_literal: true

        AnotherSample.insert_all!([
          {id: 1, sample_id: 1, string: "string", text: "text", integer: 42, float: 3.14, decimal: 0.272e1, datetime: "1776-07-04 19:14:00.000000000 +0000", time: "2000-01-01 03:15:00.000000000 +0000", date: "1863-11-19", binary: "binary", boolean: false, created_at: "1969-07-20 20:18:00.000000000 +0000", updated_at: "1989-11-10 04:20:00.000000000 +0000"},
          {id: 2, sample_id: 2, string: "string", text: "text", integer: 42, float: 3.14, decimal: 0.272e1, datetime: "1776-07-04 19:14:00.000000000 +0000", time: "2000-01-01 03:15:00.000000000 +0000", date: "1863-11-19", binary: "binary", boolean: false, created_at: "1969-07-20 20:18:00.000000000 +0000", updated_at: "1989-11-10 04:20:00.000000000 +0000"},
          {id: 3, sample_id: 3, string: "string", text: "text", integer: 42, float: 3.14, decimal: 0.272e1, datetime: "1776-07-04 19:14:00.000000000 +0000", time: "2000-01-01 03:15:00.000000000 +0000", date: "1863-11-19", binary: "binary", boolean: false, created_at: "1969-07-20 20:18:00.000000000 +0000", updated_at: "1989-11-10 04:20:00.000000000 +0000"},
        ])
      RUBY
      expect(File.read('tmp/db/seeds/yet_another_samples.rb')).to eq(<<~RUBY)
      RUBY
      expect(File.read('tmp/db/seeds/empty_models.rb')).to eq(<<~RUBY)
      RUBY
    end
  end
end
