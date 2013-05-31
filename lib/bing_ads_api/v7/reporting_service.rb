# Encoding: utf-8
#
# This is auto-generated code, changes will be overwritten.
#
# Copyright:: Copyright 2012, Google Inc. All Rights Reserved.
# License:: Licensed under the Apache License, Version 2.0.
#
# Code generated by AdsCommonBing library 0.7.3 on 2012-07-04 16:49:50.

require 'ads_common_bing_for_bing_ads/savon_service'
require 'bing_ads_api/v7/reporting_service_registry'

module BingAdsApi; module V7; module ReportingService
  class ReportingService < AdsCommonBingForBingAds::SavonService
    def initialize(config, endpoint)
      namespace = 'https://adcenter.microsoft.com/v7'
      super(config, endpoint, namespace, :v7)
    end

    def submit_generate_report(*args, &block)
      return execute_action('submit_generate_report', args, &block)
    end

    def poll_generate_report(*args, &block)
      return execute_action('poll_generate_report', args, &block)
    end

    private

    def get_service_registry()
      return ReportingServiceRegistry
    end

    def get_module()
      return BingAdsApi::V7::ReportingService
    end
  end
end; end; end
