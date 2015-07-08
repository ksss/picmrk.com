module TestHelper
  module SigninHelpers
    def signin(name = :owner)
    end

    def current_account
      accounts(@name)
    end

    def signout
      @name = nil
      find(".dropdown-toggle").click
      click_on "Sign out"
    end
  end

  module PhotosHeloers
    def upload_file
      ActionDispatch::Http::UploadedFile.new(
        filename: "testfile.jpg",
        tempfile: File.new("test/fixtures/files/icon.jpg")
      )
    end
  end

  module Extends
    include SigninHelpers
    include PhotosHeloers
  end
end
