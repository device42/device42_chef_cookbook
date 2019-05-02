# Device42 Cookbook

Provides Chef Custom Resource for accessing the Device42 REST API.

## Requirements

### Chef

- Chef 14.0+

## Attributes
 - ['device42']['instance'] - The URL of your Device42 instance.
 - ['device42']['user'] - The Device42 user with RESTful API access
 - ['device42']['password'] - Device42 API user's password

## Usage

This cookbook requires a Device42 appliance installed in your environment. Click [here](https://www.device42.com/download/) for a free trial of Device42. The Device42 instances should be configured with a signed certificate, using a self-signed certificate is not supported.

## Resources

### Device

#### Actions

 - `:create`, default: `true`

#### Properties

 - `:device_name`, String, required: true
 - `:user`, String, required: true
 - `:password`, String, required: true
 - `:url`, String, required: true

## Helpers

### IPAM

#### Methods

 - `suggest_ip(subnet)` - Suggests and reserves the next available IP in a passed subnet in Device42
 - `reserve_ip(ip)` - Reserves an passed IP in Device42