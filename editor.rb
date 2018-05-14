#!/usr/bin/env ruby

require "io/console"

class Editor
    def initialize
        lines = File.readlines("test.txt").map do |line|
            line.sub(/\n$/, "")
        end
        p lines
    end

    def run
        IO.console.raw do
            loop do
                render
                handle_input
            end
        end
    end

    def render
    end

    def handle_input
        key = $stdin.getc
        case key
        when "\C-x" then exit(0)
        end
    end
end

Editor.new.run
