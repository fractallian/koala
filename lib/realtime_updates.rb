require 'koala'

module Koala
  module Facebook
    
    class RealtimeUpdates < API
      include GraphAPIMethods
  
      attr_reader :app_id, :access_token
  
      def initialize(app_id, access_token)
        @app_id = app_id
        @access_token = access_token
      end
      
      # subscribes for realtime updates
      # your callback_url must be set up to handle the verification request or the subscription will not be set up
      # http://developers.facebook.com/docs/api/realtime
      def subscribe(object, fields, callback_url, verify_token)
        args = {
          :object => object, 
          :fields => fields,
          :callback_url => callback_url,
          :verify_token => verify_token,
          :access_token => @access_token
        }
        api(subscription_path, args, 'post')
      end
      
      # removes subscription for object
      # if object is nil, it will remove all subscriptions
      def unsubscribe(object=nil)
        args = {:access_token => @access_token}
        args[:object] = object if object
        api(subscription_path, args, 'delete')
      end
  
      def list_subscriptions
        api(subscription_path, {:access_token => @access_token}, 'get')
      end
      
      protected
      
      def subscription_path
        @subscription_path ||= "#{app_id}/subscriptions"
      end
    end
  end
end