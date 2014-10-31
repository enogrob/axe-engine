#!/usr/local/bin/ruby

require 'net/telnet.rb'

class CelloTelnet < Net::Telnet
    def login(options, password = nil)
      if options.kind_of?(Hash)
        username = options["Name"]
        password = options["Password"]
      else
        username = options
      end
      line = ''
      if block_given?
        line = waitfor(/username[: ]*\z/n){|c| yield c }
        if password
          line += cmd({"String" => username,
                       "Match" => /password[: ]*\z/n}){|c| yield c }
          line += cmd(password){|c| yield c }
        else
          line += cmd(username){|c| yield c }
        end
      else
        line = waitfor(/username[: ]*\z/n)
        if password
          line += cmd({"String" => username,
                       "Match" => /password[: ]*\z/n})
          line += cmd(password)
        else
          line += cmd(username)
        end
      end
      line
    end
    def sqlc
      self.puts("sqlc")
      self.waitfor(/SQL>[ ]?\z/n)
    end
    def sqlcend
      self.cmd("exit;")
    end
    def sqlcmd(cmdline)
      self.cmd('Match' => /SQL>[ ]?\z/n, 'String' => cmdline)
    end
end
