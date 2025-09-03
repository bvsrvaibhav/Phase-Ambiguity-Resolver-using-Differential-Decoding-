# Phase Ambiguity Resolution with Differential Decoding

In QPSK, carrier recovery cannot determine the absolute phase of the constellation. This means the received constellation can be rotated by 0°, 90°, 180°, or 270° without the receiver knowing. This is called phase ambiguity.

✦ Differential Decoding

Instead of interpreting each symbol absolutely, information is encoded in the phase difference between consecutive symbols.

At the receiver, the differential decoder compares the current symbol (
𝛿
𝑘
,
𝛿
𝑘
+
1
​

) with the previous one.

The logic in your Verilog (differential_decoder) uses a state machine / lookup table that maps these phase differences back to data bits 
(
𝑏

𝑘
,
𝑏

𝑘
+
1
)
.

Because decisions are based on relative phase, a constant constellation rotation (e.g., 90°) does not break decoding.

✅ Advantage: Robust to unknown phase shifts.

❌ Trade-off: Slightly higher error rate in noisy channels (since errors propagate over consecutive symbols).

# Unique Word (UW) Method

Another approach to resolve phase ambiguity is to transmit a known symbol sequence (unique word) at the start of a frame:

The receiver compares the received UW against the expected one.

From this, it can estimate the constellation rotation (0°, 90°, 180°, or 270°).

Once the rotation is known, all subsequent symbols are corrected accordingly.

✅ Advantage: No error propagation; works well when frames are available.

❌ Trade-off: Requires additional overhead (extra bits per frame).

# Key Difference

Differential Decoding → Works continuously, no special sequence required. Ideal for streaming data, but errors can spread across symbols.

Unique Word Method → Requires inserting a known sequence, but provides more reliable correction without error propagation. Best for packet/frame-based systems.
