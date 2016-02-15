module PagarMe
  class Model < PagarMeObject

    def create
      update PagarMe::Request.post(self.class.url, params: to_hash).run
      self
    end

    def save
      update PagarMe::Request.put(url, params: unsaved_attributes).run
      self
    end

    def url(*params)
      raise RequestError.new('Invalid ID') if id.nil? || id == ''
      self.class.url CGI.escape(id.to_s), *params
    end

    class << self

      def create(*args, &block)
        self.new(*args, &block).create
      end

      def find_by_id(id)
        raise RequestError.new('Invalid ID') if id.nil? || id == ''
        PagarMe::Request.get(url id).call
      end
      alias :find :find_by_id

      def find_by(hash, page = 1, count = 10)
        raise RequestError.new('Invalid page count') if page < 1 or count < 1

        PagarMe::Request.get(url, params: hash.merge(
          page:  page,
          count: count
        )).call
      end

      def all(page = 1, count = 10)
        find_by Hash.new, page, count
      end

      def url(*params)
        ["/#{ CGI.escape underscored_class_name }s", *params].join '/'
      end

      def class_name
        self.name.split('::').last
      end

      def underscored_class_name
        class_name.gsub(/[a-z0-9][A-Z]/){|s| "#{s[0]}_#{s[1]}"}.downcase
      end

    end
  end
end