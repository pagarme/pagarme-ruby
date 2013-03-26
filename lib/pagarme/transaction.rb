module PagarMe
	class Transaction
		attr_accessor :value

		def initialize
			@statuses_codes = { :local => 0, :approved => 1, :processing => 2, :refused => 3, :chargebacked => 4 }
			@environments_codes = { :production => 1, :development => 2 }
			@status = 0
			@environment = @environments_codes[:production]

			self.value = 0.0
		end

		def status
			return @statuses_codes.key(@status)
		end

		def live_mode=(is_live)
			@environment = is_live ? @environments_codes[:production] : @environments_codes[:development]
		end

		def live_mode
			@environment == @environments_codes[:production]
		end

		def charge
		end

		private

		def has_valid_parameters
		end
	end
end
