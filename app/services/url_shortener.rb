# app/services/url_shortener.rb
class UrlShortener
    def initialize(url)
      @url = url
    end

    def shorten
        short_code = generate_short_code
        # Create a new shortened URL record in the database
        ShortenedUrl.create(original_url: @url, short_code: short_code)

        # return the short code
        short_code
    end

    # "private" in Ruby makes all subsequent methods in the class private,
    # meaning they cannot be called with an explicit receiver from outside the class.
    private

    def generate_short_code
        # Time.now.to_f returns the current time as a floating point number of seconds since the Unix epoch
        # .to_i converts this float to an integer, truncating any decimal
        # .to_s converts this integer to a string
        # epoch_time = (Time.now.to_f * 1000).to_i.to_s(16)

        # advised to use SecureRandom for generating random alphanumeric codes
        # plus its only 6 characters long
        short_code = SecureRandom.alphanumeric(6)

        # return the short code unless it already exists in the database
        short_code unless ShortenedUrl.exists?(short_code: short_code)
    end
end

# Example usage:
# url_shortener = UrlShortener.new("https://www.google.com")
# short_code = url_shortener.shorten
# puts short_code
