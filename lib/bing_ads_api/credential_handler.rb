require 'bing_ads_api/api_config'

module BingAdsApi
  class CredentialHandler < AdsCommonBingForBingAds::CredentialHandler
    # Whether we're making MCC-level requests.
    attr_accessor :use_mcc
    # Whether we're making validate-only requests.
    attr_accessor :validate_only
    # Whether we're making partial failure requests.
    attr_accessor :partial_failure

    def initialize(config)
      super(config)
      @use_mcc = false
      @validate_only = false
      @partial_failure = false
    end

    # Create the list of credentials to be used by the auth handler for header
    # generation.
    def credentials(credentials_override = nil)
      result = super(credentials_override)
      #puts "credentials result=\n#{result}"
      validate_headers_for_server(result)

      extra_headers = {
        'userAgent' => generate_user_agent(),
        'developerToken' => result[:developer_token]
      }
      if !@use_mcc and result[:client_customer_id]
        extra_headers['clientCustomerId'] = result[:client_customer_id]
      end
      extra_headers['validateOnly'] = 'true' if @validate_only
      extra_headers['partialFailure'] = 'true' if @partial_failure
      result[:extra_headers] = extra_headers
      #puts "credentials result2=\n#{result}"
      return result
    end

    # Generates string to use as user agent in headers.
    def generate_user_agent(extra_ids = [])
      agent_app = @config.read('authentication.user_agent')
      extra_ids << ['AwApi-Ruby/%s' % BingAdsApi::ApiConfig::CLIENT_LIB_VERSION]
       super(extra_ids, agent_app)
     end

    private

    # Validates that the right credentials are being used for the chosen
    # environment.
    #
    # Raises:
    # - AdsCommonBingForBingAds::Error::EnvironmentMismatchError if sandbox credentials are
    # being used for production or vice-versa.
    # - BingAdsApi::Errors:BadCredentialsError if supplied credentials are not
    # valid.
    #
    def validate_headers_for_server(credentials)
      if credentials[:client_email]
        raise BingAdsApi::Errors::BadCredentialsError, 'Deprecated header ' +
            'clientEmail is no longer supported, please use clientCustomerId'
      end

      client_customer_id = credentials[:client_customer_id]
      if client_customer_id and
          !(client_customer_id.is_a?(Integer) or
            (client_customer_id =~ /^\d+(-\d+-\d+)?$/))
        raise BingAdsApi::Errors::BadCredentialsError,
            'Invalid client customer ID: %s' % client_customer_id.to_s
      end

      token = credentials[:developer_token]
      #sandbox_token = (token =~ /[a-zA-Z0-9]{12,}/)
      #environment = @config.read('service.environment')
      #case environment
      #  when :PRODUCTION
      #    if sandbox_token
      #      raise AdsCommonBingForBingAds::Errors::EnvironmentMismatchError,
      #          'Attempting to connect to production with sandbox credentials.'
      #    end
      #  when :SANDBOX
      #    if (!sandbox_token)
      #      raise AdsCommonBingForBingAds::Errors::EnvironmentMismatchError,
      #          'Attempting to connect to the sandbox with malformatted ' +
      #          'credentials. Please check http://msdn.microsoft.com/en-US/library/aa983013 for details.'
      #    end
      #end
      return nil
    end
  end
end