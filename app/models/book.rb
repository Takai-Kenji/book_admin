class Book < ApplicationRecord
    scope :costly, -> {where("price > ?",100000)}
    #Book.costly.written_about("java")  高単価でjavaについての本を検索する
    scope :written_about, ->(theme){ where("name like ?","%#{theme}#")}
    scope :find_price, ->(price) { find_by(price: price)}
    #Book.find_by(price:10000)は、nilが帰ってくる(クラスメソッドで定義)
    #Book.find_price(10000)は、#<ActiveRecord::Relationが帰ってくる（scopeで定義）

    belongs_to :publisher
end
