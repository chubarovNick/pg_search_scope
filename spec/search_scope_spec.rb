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
          should eq('to_tsvector(\'english\', "fruits"."name") @@ to_tsquery(\'english\', \'apples:*\')')
    end

    it 'should produce correct order sql' do
      Fruit.search_by_name('apples').order_values.first.to_sql.
          should eq('ts_rank(to_tsvector(\'english\', "fruits"."name"), to_tsquery(\'english\', \'apples:*\'), 0) DESC')
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

  context 'multiple column' do
    before do
      Fruit.send(:search_scope_for, :name, :description, {as: :ftx, wildcard: :last, language: 'english'})

      create(:fruit, name: 'apple', description: 'apple is not an orange')
      create(:fruit, name: 'orange', description: 'orange is not a pineapple')
      create(:fruit, name: 'pineapple') # null description
    end

    let(:ar_apple) { Fruit.where(name: 'apple') }
    let(:ar_orange) { Fruit.where(name: 'orange') }
    let(:ar_pineapple) { Fruit.where(name: 'pineapple') }
    let(:ar_apple_orange) { Fruit.where(name: ['apple', 'orange']) }
    let(:ar_orange_pineapple) { Fruit.where(name: ['orange', 'pineapple']) }

    it 'should find apple in fruits' do
      Fruit.ftx('apples').should match_array(ar_apple)
      Fruit.ftx('apple').should match_array(ar_apple)
      Fruit.ftx('appl').should match_array(ar_apple)
      Fruit.ftx('app').should match_array(ar_apple)
      Fruit.ftx('ap').should match_array(ar_apple)
    end

    it 'should find orange in apple and orange' do
      Fruit.ftx('orange').should match_array(ar_apple_orange)
    end

    it 'should ignore null columns' do
      Fruit.ftx('pineapple').should match_array(ar_orange_pineapple)
    end

    it 'should match with & against all columns' do
      Fruit.ftx('apple orange').should match_array(ar_apple)
    end

  end
end




