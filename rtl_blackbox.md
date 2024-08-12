### 1. **Vivado HLS 프로젝트 생성**

Vivado HLS에서 새로운 프로젝트를 생성합니다. 이 프로젝트에서 HLS 코드와 함께 사용할 Verilog RTL 모듈을 통합하게 됩니다.

### 2. **C/C++ 함수 작성**

RTL 블록을 호출할 수 있는 C/C++ 함수를 작성합니다. 이 함수는 RTL 블록의 인터페이스를 반영해야 합니다.

예를 들어, RTL 모듈이 다음과 같이 정의되어 있다고 가정합니다:

```verilog
module my_rtl_module (
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] in_data,
    output wire [31:0] out_data
);
    // RTL 모듈 구현
endmodule
```

C/C++ 코드에서 해당 RTL 모듈을 호출할 수 있는 함수를 다음과 같이 작성할 수 있습니다:

```cpp
#include "ap_int.h"

extern "C" void my_rtl_module(
    ap_uint<32> in_data,
    ap_uint<32>& out_data
);

void hls_top(ap_uint<32> in_data, ap_uint<32>& out_data) {
    #pragma HLS INTERFACE s_axilite port=in_data
    #pragma HLS INTERFACE s_axilite port=out_data
    #pragma HLS INTERFACE s_axilite port=return

    // RTL 모듈 호출
    my_rtl_module(in_data, out_data);
}
```

### 3. **JSON 파일 작성**

RTL 블랙박스를 정의하기 위해 JSON 파일을 작성합니다. 이 파일은 HLS 툴에게 RTL 모듈과 C 함수 간의 인터페이스를 알려주는 역할을 합니다.

예제 JSON 파일:

```json
{
  "c_function_name": "hls_top",
  "rtl_top_module_name": "my_rtl_module",
  "c_files": [
    {
      "c_file": "path/to/hls_top.cpp",
      "cflag": ""
    }
  ],
  "rtl_files": [
    "path/to/my_rtl_module.v"
  ],
  "c_parameters": [
    {
      "c_name": "in_data",
      "c_port_direction": "in",
      "rtl_ports": {
        "data_read_in": "in_data"
      }
    },
    {
      "c_name": "out_data",
      "c_port_direction": "out",
      "rtl_ports": {
        "data_write_out": "out_data"
      }
    }
  ],
  "rtl_common_signal": {
    "module_clock": "clk",
    "module_reset": "rst"
  },
  "rtl_performance": {
    "latency": 1,
    "II": 1
  },
  "rtl_resource_usage": {
    "FF": 10,
    "LUT": 20,
    "BRAM": 0,
    "URAM": 0,
    "DSP": 0
  }
}
```

이 JSON 파일에서는 `c_function_name`이 C/C++ 함수의 이름을, `rtl_top_module_name`이 Verilog RTL 모듈의 이름을 나타냅니다. `c_parameters` 섹션은 C 함수 파라미터와 RTL 포트 간의 매핑을 정의합니다.

### 4. **Vivado HLS에서 JSON 파일 추가**

Vivado HLS 프로젝트에 JSON 파일을 추가하여 블랙박스를 설정합니다.

- **방법 1: GUI를 통한 추가**:
  1. Vivado HLS에서 프로젝트를 열고 `Add Files` 옵션을 선택합니다.
  2. JSON 파일을 추가할 때 `Add as Blackbox` 옵션을 선택합니다.

- **방법 2: Tcl 스크립트 사용**:
  프로젝트 스크립트(`script.tcl`)에서 다음과 같은 명령을 사용하여 JSON 파일을 추가합니다:

  ```tcl
  add_files --blackbox path/to/my_blackbox.json
  ```

### 5. **C/RTL 코시뮬레이션**

HLS 설계가 올바르게 동작하는지 확인하기 위해 C/RTL 코시뮬레이션을 수행합니다. 이는 HLS에서 자동으로 생성된 C 코드와 직접 작성한 RTL 코드가 함께 올바르게 작동하는지 검증하는 과정입니다.

코시뮬레이션 실행:

```sh
cosim_design -rtl my_rtl_module
```

### 6. **HLS 합성 및 구현**

코시뮬레이션이 성공하면, HLS 합성을 진행합니다. 최종적으로 RTL 코드를 포함한 전체 시스템을 구현합니다. 이를 통해 HLS 코드와 RTL 블록이 통합된 최종 설계가 생성됩니다.

### 결론

위의 단계들을 통해 Vivado 2020.1 환경에서 RTL Blackbox 기능을 사용하여 직접 작성한 Verilog RTL 코드를 HLS 중간에 통합할 수 있습니다. 이 과정에서 중요한 점은 JSON 파일을 통해 HLS와 RTL 블록 간의 인터페이스를 정확하게 정의하고, 이를 HLS 프로젝트에 블랙박스로 추가하는 것입니다. 이러한 방식으로 HLS 코드와 RTL 코드가 함께 사용될 수 있습니다.