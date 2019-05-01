require 'spec_helper'

describe 'device42::device - create' do
  step_into :device

  context 'when creating a device' do
    recipe do
      device 'create a device' do
        device_name 'spec-test'
        user node['device42']['user']
        password node['device42']['password']
        url node['device42']['instance']
      end
    end

    message = 'name=spec-test&os=windows&osver=10.0.17763&cpucount=1&cpucore=1&cpupower=0&macaddress=11:11:11:11:11:11&memory=0&hddcount=5&hddsize=59'

    it {
      is_expected.to post_http_request('create spec-test')
        .with(
          url: device,
          message: message,
          headers: headers
        )
    }
  end
end
