; RUN: llc < %s -march=nvptx64 -mcpu=sm_35 -disable-cgp | FileCheck %s
; Disable CGP which also folds branches, so that only BranchFolding is under
; the spotlight.

target datalayout = "e-i64:64-v16:16-v32:32-n16:32:64"
target triple = "nvptx64-nvidia-cuda"

define void @foo(i32 %x, float* %output) {
; CHECK-LABEL: .visible .func foo(
; CHECK-NOT: bra.uni
; CHECK-NOT: LBB0_
  %1 = icmp eq i32 %x, 1
  br i1 %1, label %then, label %else

then:
  br label %merge

else:
  br label %merge

merge:
  store float 2.0, float* %output
  ret void
}