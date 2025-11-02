class PagesController < ApplicationController
    def home
        # In Ruby (especially in Rails controllers and views), the @ sign before a variable name (e.g., @title) makes it an instance variable.
        # This means it can be accessed in the corresponding view for this controller action.
        @title = "Aweomse URL Shortener"
        @shorten_url_path = "/shorten"
    end

    def shorten
        original_url = params[:url]

        # Create a new shortened URL record in the database
        url_shortener = UrlShortener.new(original_url)
        short_code = url_shortener.shorten

        shortened_url = "#{request.base_url}/#{short_code}"

        # Redirect with data
        redirect_to result_path(short_code: short_code)
    end

    def result
        @short_code = params[:short_code]  # Now comes from URL path, not query string
        @shortened_url = "#{request.base_url}/#{@short_code}"

        # Find the original URL from database
        shortened = ShortenedUrl.find_by(short_code: @short_code)
        @original_url = shortened&.original_url
    end

    # Redirect to the original URL
    def r
        short_code = params[:id]
        shortened = ShortenedUrl.find_by(short_code: short_code)
        if shortened
            # allow_other_host: true allows redirecting to URLs on other domains
            redirect_to shortened.original_url, allow_other_host: true
        else
            redirect_to root_path, alert: "Invalid short URL"
        end
    end
end
