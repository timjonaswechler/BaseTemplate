#extends Node
#class_name UUID
#
##region Constants
#
##endregion
#
##region Static Variables
##endregion
#
##region Static Methods
#
##endregion
#
##region Exported Variables
##endregion
#
##region Ready Variables
#func _ready() -> void:
	#pass
##endregion
#
##region Public Variables
##endregion
#
##region Method Overrides
##endregion
#
##region Public 
### https://datatracker.ietf.org/doc/rfc9562/
##UUID Version 1
##
   ##UUIDv1 is a time-based UUID featuring a 60-bit timestamp represented
   ##by Coordinated Universal Time (UTC) as a count of 100-nanosecond
   ##intervals since 00:00:00.00, 15 October 1582 (the date of Gregorian
   ##reform to the Christian calendar).
##
   ##UUIDv1 also features a clock sequence field that is used to help
   ##avoid duplicates that could arise when the clock is set backwards in
   ##time or if the Node ID changes.
##
   ##The node field consists of an IEEE 802 MAC address, usually the host
   ##address or a randomly derived value per Sections 6.9 and 6.10.
##
	##0                   1                   2                   3
	##0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
   ##+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   ##|                           time_low                            |
   ##+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   ##|           time_mid            |  ver  |       time_high       |
   ##+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   ##|var|         clock_seq         |             node              |
   ##+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   ##|                              node                             |
   ##+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
##
				   ##Figure 6: UUIDv1 Field and Bit Layout
##
   ##time_low:
	  ##The least significant 32 bits of the 60-bit starting timestamp.
	  ##Occupies bits 0 through 31 (octets 0-3).
##
   ##time_mid:
	  ##The middle 16 bits of the 60-bit starting timestamp.  Occupies
	  ##bits 32 through 47 (octets 4-5).
##
   ##ver:
	  ##The 4-bit version field as defined by Section 4.2, set to 0b0001
	  ##(1).  Occupies bits 48 through 51 of octet 6.
##
   ##time_high:
	  ##The least significant 12 bits from the 60-bit starting timestamp.
	  ##Occupies bits 52 through 63 (octets 6-7).
##
   ##var:
	  ##The 2-bit variant field as defined by Section 4.1, set to 0b10.
	  ##Occupies bits 64 and 65 of octet 8.
##
   ##clock_seq:
	  ##The 14 bits containing the clock sequence.  Occupies bits 66
	  ##through 79 (octets 8-9).
##
   ##node:
	  ##48-bit spatially unique identifier.  Occupies bits 80 through 127
	  ##(octets 10-15).
##
   ##For systems that do not have UTC available but do have the local
   ##time, they may use that instead of UTC as long as they do so
   ##consistently throughout the system.  However, this is not recommended
   ##since generating the UTC from local time only needs a time-zone
   ##offset.
##
   ##If the clock is set backwards, or if it might have been set backwards
   ##(e.g., while the system was powered off), and the UUID generator
   ##cannot be sure that no UUIDs were generated with timestamps larger
   ##than the value to which the clock was set, then the clock sequence
   ##MUST be changed.  If the previous value of the clock sequence is
   ##known, it MAY be incremented; otherwise it SHOULD be set to a random
   ##or high-quality pseudorandom value.
##
   ##Similarly, if the Node ID changes (e.g., because a network card has
   ##been moved between machines), setting the clock sequence to a random
   ##number minimizes the probability of a duplicate due to slight
   ##differences in the clock settings of the machines.  If the value of
   ##the clock sequence associated with the changed Node ID were known,
   ##then the clock sequence MAY be incremented, but that is unlikely.
##
   ##The clock sequence MUST be originally (i.e., once in the lifetime of
   ##a system) initialized to a random number to minimize the correlation
   ##across systems.  This provides maximum protection against Node IDs
   ##that may move or switch from system to system rapidly.  The initial
   ##value MUST NOT be correlated to the Node ID.
##
   ##Notes about nodes derived from IEEE 802:
##
   ##*  On systems with multiple IEEE 802 addresses, any available one MAY
	  ##be used.
##
   ##*  On systems with no IEEE address, a randomly or pseudorandomly
	  ##generated value MUST be used; see Sections 6.9 and 6.10.
##
   ##*  On systems utilizing a 64-bit MAC address, the least significant,
	  ##rightmost 48 bits MAY be used.
##
   ##*  Systems utilizing an IEEE 802.15.4 16-bit address SHOULD instead
	  ##utilize their 64-bit MAC address where the least significant,
	  ##rightmost 48 bits MAY be used.  An alternative is to generate 32
	  ##bits of random data and postfix at the end of the 16-bit MAC
	  ##address to create a 48-bit value.
#static func v1():
	### Time low component of UUID (32 bits)
	### The lowest 32 bits taken from the 60-bit timestamp
	### Stored in octets 0-3 (bits 0-31) of the UUID
	#var timestamp = Time.get_unix_time_from_system()
	#var time_low = timestamp & 0xFFFFFFFF
	#var time_mid = (timestamp >> 32) & 0xFFFF
	#var time_hi = (timestamp >> 48) & 0x0FFF
	#var version = 0x10 # Version 1
	#var variant = _variant_field()
	#var clock_seq = randi() % 16384 # 14-bit number
	#var node_id =
	  #
#
	#var clock_seq = randi() % 16384 # 14-bit number
	#
	#var _uuid = PackedByteArray()
	#
	## Time low (32 bits)
	#for i in range(4):
		#_uuid.append((int(timestamp) >> (i * 8)) & 0xFF)
	#
	## Time mid (16 bits)
	#for i in range(2):
		#_uuid.append((int(timestamp) >> ((i + 4) * 8)) & 0xFF)
	#
	## Time hi and version (16 bits)
	#_uuid.append(((int(timestamp) >> 48) & 0x0F) | 0x10) # Version 1
	#_uuid.append((int(timestamp) >> 56) & 0xFF)
	#
	## Clock sequence
	#_uuid.append((clock_seq >> 8) | 0x80) # Variant 1
	#_uuid.append(clock_seq & 0xFF)
	#
	## Node (48 bits)
	#for i in range(6):
		#_uuid.append((node_id >> (i * 8)) & 0xFF)
	#return hex(_uuid)
#
#static func v2():
	#var timestamp = Time.get_unix_time_from_system()
	#var node_id = OS.get_unique_id().hash()
	#var clock_seq = randi() % 16384
	#var domain = 0 # 0 for person, 1 for group, 2 for org
	#
	#var _uuid = PackedByteArray()
	#
	## Time low (32 bits)
	#for i in range(4):
		#_uuid.append((int(timestamp) >> (i * 8)) & 0xFF)
	#
	## Time mid (16 bits)
	#for i in range(2):
		#_uuid.append((int(timestamp) >> ((i + 4) * 8)) & 0xFF)
	#
	## Time hi and version (16 bits)
	#_uuid.append(((int(timestamp) >> 48) & 0x0F) | 0x20) # Version 2
	#_uuid.append((int(timestamp) >> 56) & 0xFF)
	#
	## Clock sequence and domain
	#_uuid.append((clock_seq >> 8) | 0x80) # Variant 1
	#_uuid.append((clock_seq & 0xFF) | (domain & 0x0F))
	#
	## Node (48 bits)
	#for i in range(6):
		#_uuid.append((node_id >> (i * 8)) & 0xFF)
	#return hex(_uuid)
#
#static func v4():
	#var _uuid = PackedByteArray()
	#
	## Generate 16 random bytes
	#for i in range(16):
		#_uuid.append(randi() % 256)
	#
	## Set version 4
	#_uuid[6] = (_uuid[6] & 0x0F) | 0x40
	#
	## Set variant 1
	#_uuid[8] = (_uuid[8] & 0x3F) | 0x80
	#
	#return hex(_uuid)
	#
#static func nil() -> String:
	#return "00000000-0000-0000-0000-000000000000"
#
#static func max() -> String:
	#return "ffffffff-ffff-ffff-ffff-ffffffffffff"
	#
#static func hex(_uuid: PackedByteArray):
	#var result = ""
	#for i in range(16):
		#if i == 4 or i == 6 or i == 8 or i == 10:
			#result += "-"
		#result += "%02x" % _uuid[i]
	#return result
#
##endregion
#
##region Private Methods
### Variant Field
   ## The variant field determines the layout of the UUID.  That is, the
   ## interpretation of all other bits in the UUID depends on the setting
   ## of the bits in the variant field.  As such, it could more accurately
   ## be called a "type" field; we retain the original term for
   ## compatibility.  The variant field consists of a variable number of
   ## the most significant bits of octet 8 of the UUID.
#
   ## Table 1 lists the contents of the variant field, where the letter "x"
   ## indicates a "don't-care" value.
#
	 ##+======+======+======+======+=========+=========================+
	 ##| MSB0 | MSB1 | MSB2 | MSB3 | Variant | Description             |
	 ##+======+======+======+======+=========+=========================+
	 ##| 0    | x    | x    | x    | 1-7     | Reserved.  Network      |
	 ##|      |      |      |      |         | Computing System (NCS)  |
	 ##|      |      |      |      |         | backward compatibility, |
	 ##|      |      |      |      |         | and includes Nil UUID   |
	 ##|      |      |      |      |         | as per Section 5.9.     |
	 ##+------+------+------+------+---------+-------------------------+
	 ##| 1    | 0    | x    | x    | 8-9,A-B | The variant specified   |
	 ##|      |      |      |      |         | in this document.       |
	 ##+------+------+------+------+---------+-------------------------+
	 ##| 1    | 1    | 0    | x    | C-D     | Reserved.  Microsoft    |
	 ##|      |      |      |      |         | Corporation backward    |
	 ##|      |      |      |      |         | compatibility.          |
	 ##+------+------+------+------+---------+-------------------------+
	 ##| 1    | 1    | 1    | x    | E-F     | Reserved for future     |
	 ##|      |      |      |      |         | definition and includes |
	 ##|      |      |      |      |         | Max UUID as per         |
	 ##|      |      |      |      |         | Section 5.10.           |
	 ##+------+------+------+------+---------+-------------------------+
	 #func _variant_field():
		#return 0x80
##endregion
#
##region Private Variables
#
##endregion
