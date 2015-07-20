# encoding: utf-8
require File.join(File.dirname(__FILE__), '..', 'pagarme')

module PagarMe
	class TransactionCommon < Model

		def initialize(response = {})
			super(response)

			self.payment_method ||= 'credit_card'
			self.installments ||= 1
			self.status ||= 'local'
		end

		def create
			check_card_object
			super
		end

		def save
			check_card_object
			super
		end

		private

		def check_card_object
			if self.card
				if self.card.id
					self.card_id = self.card.id
				else
					self.card_number = self.card.card_number
					self.card_holder_name = self.card.card_holder_name
					self.card_expiration_year = self.card.card_expiration_year
					self.card_expiration_month = self.card.card_expiration_month
					self.card_cvv = self.card.card_cvv
				end
				self.card = nil
			end

			self.card_expiration_date ||= "#{self.card_expiration_month}#{self.card_expiration_year}"
		end
	end
end
