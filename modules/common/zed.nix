
{ pkgs, lib, config, ... }:

{
  age.secrets."zed-sanity-mcp" = {
    file = ../../secrets/zed-sanity-mcp.age;
  } // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
    path = "${config.home.homeDirectory}/.config/environment.d/zed.conf";
  };

  programs.zsh.initContent = ''
      if [ -f "${config.age.secrets."zed-sanity-mcp".path}" ]; then
        set -a
        source "${config.age.secrets."zed-sanity-mcp".path}"
        set +a
        ${lib.optionalString pkgs.stdenv.isDarwin ''
          launchctl setenv SANITY_MCP_TOKEN "$SANITY_MCP_TOKEN"
        ''}
      fi
    '';

  programs.zed-editor = {
    enable = true;
    package = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin null;

    # Required for your Catppuccin themes, icons, and Astro syntax support
    extensions = [
      "catppuccin"
      "catppuccin-icons"
      "nix"
      "astro"
    ];

    userSettings = {
      show_edit_predictions = true;
      window_title_format = "\${projectName}\${separator}\${fileName}";
      proxy = "";

      terminal = {
        font_family = "FiraCode Nerd Font Mono";
      };

      load_direnv = "direct";

      lsp = {
        basedpyright = {
          binary = {
            path = "direnv";
            arguments = [ "exec" "." "basedpyright-langserver" "--stdio" ];
          };
        };
        ruff = {
          binary = {
            path = "direnv";
            arguments = [ "exec" "." "ruff" "server" ];
          };
        };
      };

      icon_theme = {
        mode = "system";
        light = "Catppuccin Latte";
        dark = "Catppuccin Latte";
      };

      cli_default_open_behavior = "existing_window";

      project_panel.dock = "left";
      outline_panel.dock = "left";
      collaboration_panel.dock = "left";
      git_panel.dock = "left";

      disable_ai = false;
      relative_line_numbers = "enabled";

      prettier = {
        allowed = true;
      };

      ssh_connections = [
        {
          host = "dev.fosshaug.xyz";
          username = "root";
          args = [ ];
          projects = [
            { paths = [ "/root/IN3030" ]; }
            { paths = [ "/root/IN3230" ]; }
            { paths = [ "/root/c-practice" ]; }
            { paths = [ "/root/projects" ]; }
          ];
          nickname = "devServer";
        }
        {
          host = "dev.fosshaug.xyz";
          username = "andreas";
          args = [ ];
          projects = [
            { paths = [ "/home/andreas/ml-learning/practice/pizzas/./" ]; }
            { paths = [ "/home/andreas/projects" ]; }
            { paths = [ "/home/andreas/projects/alias" ]; }
          ];
        }
        {
          host = "dev.fosshaug.xyz";
          username = "andreas";
          args = [ ];
          projects = [ ];
        }
        {
          host = "in3230-vm";
          args = [ ];
          projects = [
            { paths = [ "/home/ubuntu/oblig" ]; }
          ];
        }
        {
          host = "2001:700:2:8201::153d";
          username = "debian";
          args = [ "-J" "andfo@morgoth.uio.no" ];
          projects = [
            { paths = [ "/home/debian/oblig2" ]; }
          ];
          nickname = "network-oblig";
        }
        {
          host = "devServer";
          args = [ ];
          projects = [ ];
        }
        {
          host = "in3230";
          args = [ ];
          projects = [ ];
        }
        {
          host = "192.168.68.30";
          username = "andreas";
          args = [ ];
          projects = [
            { paths = [ "/etc/nixos/./" ]; }
          ];
        }
        {
          host = "192.168.68.30";
          username = "root";
          args = [ ];
          projects = [
            { paths = [ "/etc/nixos" ]; }
          ];
        }
        {
          host = "192.168.68.30";
          username = "andreas";
          args = [ ];
          projects = [
            { paths = [ "/home/andreas/projects/dgf/./" ]; }
            { paths = [ "/home/andreas/projects/dgf/dgf/./" ]; }
          ];
        }
        {
          host = "192.168.68.30";
          username = "andreas";
          args = [ ];
          projects = [ ];
        }
      ];

      edit_predictions = {
        open_ai_compatible_api = {
          model = "";
          api_url = "http://localhost:11234/v1";
        };
        allow_data_collection = "no";
        ollama = {
          prompt_format = "qwen";
          api_url = "http://localhost:11234/v1/responses";
          max_output_tokens = 32;
          prediction_debounce = 200;
          model = "Qwen2.5-Coder-0.5B-Instruct-4bit";
        };
        provider = "ollama";
      };

      agent = {
        default_profile = "write";
        enable_feedback = false;
        dock = "right";
        play_sound_when_agent_done = "always";
        default_model = {
          enable_thinking = false;
          provider = "mlx-serve";
          model = "ddalcu/Qwen3.6-35B-A3B-MLX-Serve-4bit";
        };
      };

      language_models = {
        openai_compatible = {
          mlx-serve = {
            api_url = "http://localhost:11234/v1";
            available_models = [
              {
                name = "ddalcu/Qwen3.6-35B-A3B-MLX-Serve-4bit";
                max_tokens = 200000;
                max_output_tokens = 32000;
                max_completion_tokens = 200000;
                reasoning_effort = "medium";
                capabilities = {
                  tools = true;
                  images = false;
                  parallel_tool_calls = false;
                  prompt_cache_key = false;
                  chat_completions = true;
                  interleaved_reasoning = false;
                  max_tokens_parameter = false;
                };
              }
            ];
          };
        };
      };

      languages = {
        Java = {
          show_whitespaces = "all";
          preferred_line_length = 86;
          hard_tabs = true;
          format_on_save = "on";
          remove_trailing_whitespace_on_save = true;
        };
        Astro = {
          tab_size = 2;
          hard_tabs = false;
          format_on_save = "on";
          formatter = {
            external = {
              command = "npx";
              arguments = [ "prettier" "--stdin-filepath" "{buffer_path}" ];
            };
          };
        };
        Python = {
          formatter = {
            language_server = {
              name = "ruff";
            };
          };
          format_on_save = "on";
          code_actions_on_format = {
            "source.organiseImports.ruff" = true;
            "source.fixAll.ruff" = true;
          };
        };
      };

      vim_mode = true;
      ui_font_size = 16;
      buffer_font_size = 16;

      theme = {
        mode = "system";
        light = "Catppuccin Latte";
        dark = "Catppuccin Mocha";
      };

      formatter = {
        external = {
          command = "prettier";
          arguments = [ "--stdin-filepath" "{buffer_path}" ];
        };
      };

      file_scan_exclusions = [
        "*.class"
      ];

      context_servers = {
        Sanity = {
          enabled = true;
          headers = {
            Authorization = "Bearer \${SANITY_MCP_TOKEN}";
          };
          url = "https://mcp.sanity.io";
        };
      };
    };
  };
}
