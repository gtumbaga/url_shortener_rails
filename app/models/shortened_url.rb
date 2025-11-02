class ShortenedUrl < ApplicationRecord
    # Soft delete
    def destroy
        update(deleted_at: Time.current)
    end

    # Scope to only get non-deleted records
    scope :active, -> { where(deleted_at: nil) }
end
