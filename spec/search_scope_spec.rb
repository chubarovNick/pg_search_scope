require 'spec_helper'

describe 'search scope' do

  context 'single column' do
    before do
      Fruit.send(:search_scope_for, :name, {wildcard: :last, language: 'english'})

      create(:fruit, name: 'apple')
      create(:fruit, name: 'orange')
      create(:fruit, name: 'pineapple')
    end

    let(:ar_apple) { Fruit.where(name: 'apple') }
    let(:ar_orange) { Fruit.where(name: 'orange') }
    let(:ar_pineapple) { Fruit.where(name: 'pineapple') }

    it 'should produce correct where sql' do
      Fruit.search_by_name('apples').where_values.first.to_sql.
          should eq('to_tsvector(\'english\', concat_ws(\' \', "fruits"."name")) @@ to_tsquery(\'english\', concat_ws(\'&\', \'apples:*\'))')
    end

    it 'should produce correct order sql' do
      Fruit.search_by_name('apples').order_values.first.to_sql.
          should eq('ts_rank(to_tsvector(\'english\', concat_ws(\' \', "fruits"."name")), to_tsquery(\'english\', concat_ws(\'&\', \'apples:*\')), 0) DESC')
    end

    it 'should find fruits by plural form of name' do
      Fruit.search_by_name('apples').should match_array(ar_apple)
    end

    it 'should find fruits by name' do
      Fruit.search_by_name('apple').should match_array(ar_apple)
    end

    it 'should find fruits by name part' do
      Fruit.search_by_name('appl').should match_array(ar_apple)
      Fruit.search_by_name('app').should match_array(ar_apple)
      Fruit.search_by_name('ap').should match_array(ar_apple)
    end

  end
end




