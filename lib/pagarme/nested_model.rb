module PagarMe
  class NestedModel < Model
    attr_reader :parent_id

    def initialize(hash = Hash.new)
      hash = hash.dup
      @parent_id = hash.delete(:parent_id) || hash.delete('parent_id')
      super hash
    end

    def create
      update PagarMe::Request.post(self.class.url(parent_id), params: to_hash).run
      self
    end

    def url(*params)
      raise RequestError.new('Invalid ID') unless id.present?
      self.class.url parent_id, CGI.escape(id.to_s), *params
    end

    class << self

      def parent_resource_name
        raise NotImplementedError
      end

      def find_by_id(parent_id, id)
        raise RequestError.new('Invalid ID')        unless        id.present?
        raise RequestError.new('Invalid parent ID') unless parent_id.present?

        PagarMe::Request.get(url parent_id, id).call
      end
      alias :find :find_by_id

      def find_by(parent_id, hash, page = 1, count = 10)
        raise RequestError.new('Invalid page count') if page < 1 or count < 1

        PagarMe::Request.get(url(parent_id), params: hash.merge(
          page:  page,
          count: count
        )).call
      end
      alias :find_by_hash :find_by

      def all(parent_id, page = 1, count = 10)
        find_by parent_id, Hash.new, page, count
      end

      def url(parent_id, *params)
        raise RequestError.new('Invalid parent ID') unless parent_id.present?
        ["/#{parent_resource_name}", parent_id, "#{ CGI.escape underscored_class_name }s", *params].join '/'
      end

    end
  end
end