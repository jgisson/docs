#!/bin/bash

# Ollama Startup Script
# Starts Ollama server with custom configuration:
# - Keep models in memory for 1 hour
# - Loads ministral-3:14b with 16k context window (64k context takes a lot of RAM)

set -e

# Configuration
MODEL_BASE="ministral-3:14b"
MODEL_CUSTOM="ministral-3-16k"
CONTEXT_SIZE=16384
KEEP_ALIVE="1h"
OLLAMA_PORT=11434
OLLAMA_HOST="http://localhost:${OLLAMA_PORT}"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print colored messages
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "  $1"
}

# Check if Ollama is installed
check_ollama_installed() {
    if ! command -v ollama &> /dev/null; then
        print_error "Ollama is not installed"
        echo "Install it from: https://ollama.ai"
        exit 1
    fi
    print_success "Ollama is installed"
}

# Check if Ollama server is running
is_ollama_running() {
    if curl -s "${OLLAMA_HOST}/api/tags" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Wait for Ollama server to be ready
wait_for_server() {
    local max_attempts=30
    local attempt=0

    print_info "Waiting for Ollama server to start..."

    while [ $attempt -lt $max_attempts ]; do
        if curl -s "${OLLAMA_HOST}/api/tags" &> /dev/null; then
            print_success "Ollama server is ready"
            return 0
        fi
        sleep 1
        attempt=$((attempt + 1))
    done

    print_error "Ollama server failed to start within 30 seconds"
    return 1
}

# Check if a model exists
model_exists() {
    local model_name=$1
    if ollama list | grep -q "^${model_name}"; then
        return 0
    else
        return 1
    fi
}

# Start Ollama server
start_server() {
    if is_ollama_running; then
        print_warning "Ollama server is already running"
        return 0
    fi

    print_info "Starting Ollama server with KEEP_ALIVE=${KEEP_ALIVE}..."

    # Export keep alive setting and start server in background
    export OLLAMA_KEEP_ALIVE="${KEEP_ALIVE}"
    nohup ollama serve > /tmp/ollama-server.log 2>&1 &

    local server_pid=$!
    echo $server_pid > /tmp/ollama-server.pid

    # Wait for server to be ready
    if wait_for_server; then
        print_success "Ollama server started (PID: ${server_pid})"
        return 0
    else
        print_error "Failed to start Ollama server"
        return 1
    fi
}

# Setup model with custom configuration
setup_model() {
    # Check if base model exists
    print_info "Checking for base model: ${MODEL_BASE}..."
    if ! model_exists "${MODEL_BASE}"; then
        print_warning "Base model not found. Pulling ${MODEL_BASE}..."
        print_info "This may take several minutes..."

        if ollama pull "${MODEL_BASE}"; then
            print_success "Base model pulled successfully"
        else
            print_error "Failed to pull base model"
            return 1
        fi
    else
        print_success "Base model found: ${MODEL_BASE}"
    fi

    # Check if custom model already exists
    if model_exists "${MODEL_CUSTOM}"; then
        print_success "Custom model already exists: ${MODEL_CUSTOM}"
        return 0
    fi

    # Create Modelfile
    print_info "Creating custom model with ${CONTEXT_SIZE} context window..."
    local modelfile="/tmp/ollama-${MODEL_CUSTOM}.modelfile"

    cat > "${modelfile}" <<EOF
FROM ${MODEL_BASE}
PARAMETER num_ctx ${CONTEXT_SIZE}
EOF

    # Create custom model
    if ollama create "${MODEL_CUSTOM}" -f "${modelfile}"; then
        print_success "Custom model created: ${MODEL_CUSTOM}"
        rm -f "${modelfile}"
        return 0
    else
        print_error "Failed to create custom model"
        rm -f "${modelfile}"
        return 1
    fi
}

# Load model into memory
load_model() {
    print_info "Loading ${MODEL_CUSTOM} into memory..."

    # Send a simple prompt to load the model
    if echo "Hello" | ollama run "${MODEL_CUSTOM}" > /dev/null 2>&1; then
        print_success "Model loaded into memory"
        return 0
    else
        print_warning "Could not pre-load model (will load on first use)"
        return 0
    fi
}

# Display status
show_status() {
    echo ""
    echo "═══════════════════════════════════════════"
    echo "  Ollama Server Status"
    echo "═══════════════════════════════════════════"

    if is_ollama_running; then
        print_success "Server: Running on ${OLLAMA_HOST}"

        if [ -f /tmp/ollama-server.pid ]; then
            local pid=$(cat /tmp/ollama-server.pid)
            print_info "PID: ${pid}"
        fi

        print_info "Keep Alive: ${KEEP_ALIVE}"
        echo ""

        print_success "Model: ${MODEL_CUSTOM}"
        print_info "Base: ${MODEL_BASE}"
        print_info "Context Window: ${CONTEXT_SIZE} tokens"
        echo ""

        echo "Usage:"
        print_info "ollama run ${MODEL_CUSTOM} \"Your prompt here\""
        echo ""

        echo "Stop server:"
        print_info "pkill ollama"
    else
        print_error "Server: Not running"
    fi

    echo "═══════════════════════════════════════════"
}

# Stop Ollama server
stop_server() {
    if ! is_ollama_running; then
        print_warning "Ollama server is not running"
        return 0
    fi

    print_info "Stopping Ollama server..."
    pkill ollama || true

    # Wait for server to stop
    sleep 2

    if ! is_ollama_running; then
        print_success "Ollama server stopped"
        rm -f /tmp/ollama-server.pid
        return 0
    else
        print_error "Failed to stop Ollama server"
        return 1
    fi
}

# Show help
show_help() {
    cat << EOF
Ollama Startup Script

Usage: $0 [OPTION]

Options:
  (no option)    Start Ollama server with custom configuration
  --status       Show current Ollama server status
  --stop         Stop Ollama server
  --help         Show this help message

Configuration:
  Model:         ${MODEL_CUSTOM} (based on ${MODEL_BASE})
  Context:       ${CONTEXT_SIZE} tokens (64k)
  Keep Alive:    ${KEEP_ALIVE} (models stay in memory)
  Port:          ${OLLAMA_PORT}

Examples:
  ./ollama-start.sh           # Start server and setup model
  ./ollama-start.sh --status  # Check server status
  ./ollama-start.sh --stop    # Stop server

EOF
}

# Main script logic
main() {
    case "${1:-}" in
        --status)
            show_status
            exit 0
            ;;
        --stop)
            stop_server
            exit $?
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        "")
            echo ""
            echo "Starting Ollama with custom configuration..."
            echo ""

            check_ollama_installed

            if ! start_server; then
                exit 1
            fi

            if ! setup_model; then
                print_error "Failed to setup model"
                exit 1
            fi

            load_model

            show_status
            ;;
        *)
            print_error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
