module CodePraise
  module Gnews
    #Data Mapper object for google news article
    class ArticlesMapper
      def initialize(gateway)
        @gateway = gateway
      end
      
      def load(source)
        articles_data = @gateway.articles_data(source)
        sources = SourcesMapper.new(@gateway).load
        sources.each do |s|
          source = s if s.id == source 
        end
        build_entity(articles_data['articles'], source)
      end
      
      def build_entity(articles_data, source)
        articles_data.map { |article_data| DataMapper.new(article_data, source).build_entity }
      end
      
      class DataMapper
        
        def initialize(article_data, source)
          @article_data = article_data
          @source = source
        end
        
        def build_entity
          Entity::Article.new(
            origin_id: self.author,
            title: self.title,
            description: self.description,
            url: self.url,
            source: @source
          )
        end
        
        def author
          @article_data['author']
        end
     
        def title
          @article_data['title']
        end
     
        def description
          @article_data['description']
        end
     
        def url
          @article_data['url']
        end
      end
    end
  end
end