#!/usr/bin/env ruby

class Editor
    def initialize
        lines = File.readlines("test.txt").map do |line|
            line.sub(/\n$/, "")
        end
        p lines
    end

    def run
        loop do
            render
            handle_input
        end
    end

    def render
    end

    def handle_input
    end
end

Editor.new
