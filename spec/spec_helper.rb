require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
  config.log_level = :error
  config.alias_example_group_to :describe, type: :default_recipe
  config.fail_fast = true
  config.expect_with :rspec do |c|
    c.max_formatted_output_length = nil
  end
end

shared_context 'converged default recipe', type: :default_recipe do
  platform 'ubuntu'
  platform 'windows'

  default_attributes['device42']['instance'] = 'http://heartofgold.device42.com'
  default_attributes['device42']['user'] = 'admin'
  default_attributes['device42']['password'] = 'abc123'

  # Node ohai attributes
  default_attributes['cpu']['0']['cores'] = 1
  default_attributes['cs_info']['total_physical_memory'] = 4098
  default_attributes['filesystem']['by_device'] = {
    "/dev/mapper/centos-root": {
      "kb_size": '42954248',
      "kb_used": '1136704',
      "kb_available": '41817544',
      "percent_used": '3%',
      "total_inodes": '21487616',
      "inodes_used": '40254',
      "inodes_available": '21447362',
      "inodes_percent_used": '1%',
      "fs_type": 'xfs',
      "mount_options": %w(
        rw
        relatime
        seclabel
        attr2
        inode64
        noquota
      ),
      "uuid": '5193bb03-3985-42e7-aeb2-ded1f3ee4a80',
      "mounts": [
        '/',
      ],
    },
    "devtmpfs": {
      "kb_size": '495820',
      "kb_used": '0',
      "kb_available": '495820',
      "percent_used": '0%',
      "total_inodes": '123955',
      "inodes_used": '330',
      "inodes_available": '123625',
      "inodes_percent_used": '1%',
      "fs_type": 'devtmpfs',
      "mount_options": [
        'rw',
        'nosuid',
        'seclabel',
        'size=495820k',
        'nr_inodes=123955',
        'mode=755',
      ],
      "mounts": [
        '/dev',
      ],
    },
    "tmpfs": {
      "kb_size": '101500',
      "kb_used": '0',
      "kb_available": '101500',
      "percent_used": '0%',
      "total_inodes": '126871',
      "inodes_used": '1',
      "inodes_available": '126870',
      "inodes_percent_used": '1%',
      "fs_type": 'tmpfs',
      "mount_options": [
        'rw',
        'nosuid',
        'nodev',
        'relatime',
        'seclabel',
        'size=101500k',
        'mode=700',
        'uid=1000',
        'gid=1000',
      ],
      "mounts": [
        '/dev/shm',
        '/run',
        '/sys/fs/cgroup',
        '/run/user/1000',
      ],
    },
    "/dev/mapper/centos-home": {
      "kb_size": '20969468',
      "kb_used": '33012',
      "kb_available": '20936456',
      "percent_used": '1%',
      "total_inodes": '10489856',
      "inodes_used": '10',
      "inodes_available": '10489846',
      "inodes_percent_used": '1%',
      "fs_type": 'xfs',
      "mount_options": %w(
        rw
        relatime
        seclabel
        attr2
        inode64
        noquota
      ),
      "uuid": 'ac727159-6859-4ece-a821-b065276c605e',
      "mounts": [
        '/home',
      ],
    },
    "/dev/sda1": {
      "kb_size": '1038336',
      "kb_used": '132016',
      "kb_available": '906320',
      "percent_used": '13%',
      "total_inodes": '524288',
      "inodes_used": '292',
      "inodes_available": '523996',
      "inodes_percent_used": '1%',
      "fs_type": 'xfs',
      "mount_options": %w(
        rw
        relatime
        seclabel
        attr2
        inode64
        noquota
      ),
      "uuid": '24cc07d5-4da0-46a1-b0c2-0f7e94d20b8c',
      "mounts": [
        '/boot',
      ],
    },
  }

  let(:headers) do
    {
      'Authorization': 'Basic YWRtaW46YWJjMTIz',
    }
  end

  namespace = {
    device: 'devices',
    ips: 'ips',
    suggest_ip: 'suggest_ip',
  }

  namespace.each do |key, value|
    let(key) do
      ::File.join('http://heartofgold.device42.com', 'api/1.0', value, '/')
    end
  end
end
