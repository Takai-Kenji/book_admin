class Book < ApplicationRecord
    scope :costly, -> {where("price > ?",100000)}
    #Book.costly.written_about("java")  高単価でjavaについての本を検索する
    scope :written_about, ->(theme){ where("name like ?","%#{theme}#")}
    scope :find_price, ->(price) { find_by(price: price)}
    #Book.find_by(price:10000)は、nilが帰ってくる(クラスメソッドで定義)
    #Book.find_price(10000)は、#<ActiveRecord::Relationが帰ってくる（scopeで定義）

    belongs_to :publisher
    has_many :book_authors
    has_many :authors,through: :book_authors

    validates :name, presence:true
    validates :name, length: { maximum: 25 }
    validates :price, numericality: { greater_than_or_equal_to: 0}

    #独自のバリデーション
    validate do |book|
        if book.name.include?("ishwor")
            book.errors[:name] << "Don't use the name of GOD."
        end
    end

    #Cat -> lovely cat
    before_validation :add_lovely_to_cat

    def add_lovely_to_cat
        self.name = self.name.gsub(/Cat/) do |matched|
            "lovely #{matched}"
        end
    end

    #write log
    after_destroy do
        Rails.logger.info "Book is deleted: #{self.attributes}"
    end

    after_destroy :if => :high_price? do
        Rails.logger.warn "Book with high price is deleted: #{self.attributes}"
        Rails.logger.warn "Please check!!"
    end

    def high_price?
        price >= 5000
    end

    #enumクラスのカラム名と対応する値の定義
    enum sales_status: {
        reservation: 0, #予約販売中
        now_on_sale: 1, #発売中
        end_of_print: 2, #販売終了
    }
end
