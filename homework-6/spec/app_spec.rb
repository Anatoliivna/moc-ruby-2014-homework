

require File.expand_path '../spec_helper.rb', __FILE__


class MyAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_my_default
    get '/'
    assert_equal 'British Secret Service', last_response.body
  end

  def test_with_params
    get '/about', :name => 'MI6'
    assert_equal 'The Secret Intelligence Service (SIS)', last_response.body
  end

  def test_login_success
    post '/login', :username => 'James', :password =>'007'
    assert_equal 'Wellcome, Mr. Bond!' , last_response.body
  end

  def test_post_failed
    post '/login', :username => 'test', :password =>'test'
    assert_equal 'Error' , last_response.body
  end

  def test_intercalary_success
    get '/years/2020'
    assert_equal 'true', last_response.body
  end

  def test_intercalary_failed
    get '/years/2022'
    assert_equal 'false', last_response.body
  end

  def test_intercalary_tricky_success
    get '/years/2000'
    assert_equal 'true', last_response.body
  end

  def test_intercalary_tricky_failed
    get '/years/1900'
    assert_equal 'false', last_response.body
  end

end