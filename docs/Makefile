BUILD_DIR=build

$(BUILD_DIR)/fsk.pdf: fsk.typst $(BUILD_DIR)
	typst compile fsk.typst $(BUILD_DIR)/fsk.pdf

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

.phony clean:
clean:
	rm -rf $(BUILD_DIR)
