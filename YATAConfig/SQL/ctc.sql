/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

CREATE TABLE IF NOT EXISTS `currencies_ctc` (
  `PRTY` int(11) NOT NULL DEFAULT 999,
  `SYMBOL` varchar(8) NOT NULL,
  `NAME` varchar(64) NOT NULL,
  `DECIMALS` int(11) NOT NULL,
  `ACTIVE` tinyint(4) NOT NULL,
  `FEE` double DEFAULT 0,
  PRIMARY KEY (`SYMBOL`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `currencies_ctc` DISABLE KEYS */;
INSERT IGNORE INTO `currencies_ctc` (`PRTY`, `SYMBOL`, `NAME`, `DECIMALS`, `ACTIVE`, `FEE`) VALUES
	(500, '1CR', '1Credit', 6, 1, 0),
	(501, 'ABY', 'ArtByte', 6, 1, 0),
	(502, 'AC', 'AsiaCoin', 6, 1, 0),
	(503, 'ACH', 'AchieveCoin', 6, 1, 0),
	(504, 'ADN', 'Aiden', 6, 1, 0),
	(505, 'AEON', 'Aeon', 6, 1, 0),
	(506, 'AERO', 'CryptoAero', 6, 1, 0),
	(507, 'AIR', 'AirToken', 6, 1, 0),
	(768, 'AMP', 'HyperSpace', 6, 1, 0),
	(508, 'APH', 'Aphelion', 6, 1, 0),
	(755, 'ARCH', 'ARCHCoin', 6, 1, 0),
	(778, 'ARDR', 'ARDR', 6, 1, 0),
	(59, 'AUR', 'AuroraCoin', 6, 1, 0),
	(510, 'AXIS', 'AxisCoin', 6, 1, 0),
	(511, 'BALLS', 'SnowBalls', 6, 1, 0),
	(512, 'BANK', 'BANK', 6, 1, 0),
	(795, 'BAT', 'Basic Attentio Token', 6, 1, 0),
	(513, 'BBL', 'BitBlock', 6, 1, 0),
	(514, 'BBR', 'BoolBerry', 6, 1, 0),
	(515, 'BCC', 'BitConnect', 6, 1, 0),
	(4, 'BCH', 'Bitcoin Cash', 6, 1, 0),
	(801, 'BCHABC', 'Bitcoin Cash ABC', 6, 1, 0),
	(14, 'BCHSV', 'Bitcoin SV', 6, 1, 0),
	(42, 'BCN', 'Bytecoin', 6, 1, 0),
	(762, 'BCY', 'BitCrystals', 6, 1, 0),
	(517, 'BDC', 'Bollywood Coin', 6, 1, 0),
	(518, 'BDG', 'BitDegree', 6, 1, 0),
	(519, 'BELA', 'BELA Coin', 6, 1, 0),
	(766, 'BITCNY', 'bitCNY', 6, 1, 0),
	(520, 'BITS', 'Bitstart', 6, 1, 0),
	(765, 'BITUSD', 'bitUSD', 6, 1, 0),
	(521, 'BLK', 'Black Coin', 6, 1, 0),
	(522, 'BLOCK', 'Block Net', 6, 1, 0),
	(523, 'BLU', 'BlueCoin', 6, 1, 0),
	(524, 'BNS', 'BonusCoin', 6, 1, 0),
	(798, 'BNT', 'Bancor', 6, 1, 0),
	(525, 'BONES', 'Bones Cryptocoin', 6, 1, 0),
	(526, 'BOST', 'BoostCoin', 6, 1, 0),
	(1, 'BTC', 'Bitcoin', 6, 1, 0),
	(528, 'BTCD', 'Bitcoin Dark', 6, 1, 0),
	(529, 'BTCS', 'Bitcoin Shop', 6, 1, 0),
	(530, 'BTM', 'Bytom', 6, 1, 0),
	(45, 'BTS', 'Bitshares', 6, 1, 0),
	(532, 'BURN', 'BURN Cryptocoin', 6, 1, 0),
	(533, 'BURST', 'Burst Cryptocoin', 6, 1, 0),
	(534, 'C2', 'Coin 2.1', 6, 1, 0),
	(535, 'CACH', 'CacheCoin', 6, 1, 0),
	(536, 'CAI', 'CAI Token', 6, 1, 0),
	(537, 'CC', 'CyberCoin', 6, 1, 0),
	(538, 'CCN', 'CannaCoin', 6, 1, 0),
	(539, 'CGA', 'Cryptografic Anomaly', 6, 1, 0),
	(540, 'CHA', 'ChanceCoin', 6, 1, 0),
	(541, 'CINNI', 'CinniCoin', 6, 1, 0),
	(542, 'CLAM', 'Clams', 6, 1, 0),
	(543, 'CNL', 'ConcealCoin', 6, 1, 0),
	(544, 'CNMT', 'CNMT', 6, 1, 0),
	(545, 'CNOTE', 'CryptoNote', 6, 1, 0),
	(546, 'COMM', 'COMM', 6, 1, 0),
	(547, 'CON', 'PayCon', 6, 1, 0),
	(548, 'CORG', 'CorgiCoin', 6, 1, 0),
	(549, 'CRYPT', 'CryptCoin', 6, 1, 0),
	(550, 'CURE', 'CureCoin', 6, 1, 0),
	(787, 'CVC', 'Civic', 6, 1, 0),
	(551, 'CYC', 'Cycling Coin', 6, 1, 0),
	(772, 'DAO', 'Decentralized Autonomous Organization', 6, 1, 0),
	(13, 'DASH', 'Dash', 6, 1, 0),
	(30, 'DCR', 'Decred', 6, 1, 0),
	(47, 'DGB', 'DigiByte', 6, 1, 0),
	(553, 'DICE', 'Etheroll', 6, 1, 0),
	(554, 'DIEM', 'Carpe Diem Coin', 6, 1, 0),
	(555, 'DIME', 'Dime Coin', 6, 1, 0),
	(556, 'DIS', 'Distrocoin', 6, 1, 0),
	(557, 'DNS', 'DNSCrypt', 6, 1, 0),
	(26, 'DOGE', 'DogeCoin', 6, 1, 0),
	(560, 'DRKC', 'Dark Cash', 6, 1, 0),
	(561, 'DRM', 'DreamCoin', 6, 1, 0),
	(562, 'DSH', 'Dashcoin', 6, 1, 0),
	(563, 'DVK', 'DvoraKoin', 6, 1, 0),
	(564, 'EAC', 'EarthCoin', 6, 1, 0),
	(565, 'EBT', 'Ebittree Coin', 6, 1, 0),
	(566, 'ECC', 'ECC Coin', 6, 1, 0),
	(567, 'EFL', 'e-Gulden', 6, 1, 0),
	(568, 'EMC2', 'Einsteinium', 6, 1, 0),
	(569, 'EMO', 'Emoticoint', 6, 1, 0),
	(570, 'ENC', 'EntropyCoin', 6, 1, 0),
	(6, 'EOS', 'Crypt/EOS', 6, 1, 0),
	(18, 'ETC', 'Ethereum Classic', 6, 1, 0),
	(2, 'ETH', 'Ethereum', 6, 1, 0),
	(571, 'eTOK', 'eTOK', 6, 1, 0),
	(572, 'EXE', 'ExeCoin', 6, 1, 0),
	(763, 'EXP', 'Expanse', 6, 1, 0),
	(573, 'FAC', 'FAC', 6, 1, 0),
	(574, 'FCN', 'FantomCoin', 6, 1, 0),
	(66, 'FCT', 'Factom', 6, 1, 0),
	(575, 'FIBRE', 'FIBRE Cryptocoin', 6, 1, 0),
	(576, 'FLAP', 'FlappyCoin', 6, 1, 0),
	(577, 'FLDC', 'FoldingCoin', 6, 1, 0),
	(753, 'FLO', 'Florin', 6, 1, 0),
	(578, 'FLT', 'FlutterCoin', 6, 1, 0),
	(800, 'FOAM', 'FOAM Protocol', 6, 1, 0),
	(579, 'FOX', 'FoxCoin', 6, 1, 0),
	(580, 'FRAC', 'FractalCoin', 6, 1, 0),
	(581, 'FRK', 'Franko', 6, 1, 0),
	(582, 'FRQ', 'FairQuark', 6, 1, 0),
	(583, 'FVZ', 'FVZCoin', 6, 1, 0),
	(584, 'FZ', 'Frozen', 6, 1, 0),
	(585, 'FZN', 'Fuzon', 6, 1, 0),
	(592, 'GAME', 'GameCredits', 6, 1, 0),
	(586, 'GAP', 'GapCoin', 6, 1, 0),
	(789, 'GAS', 'GAS Neo', 6, 1, 0),
	(587, 'GDN', 'Global Denomination', 6, 1, 0),
	(588, 'GEMZ', 'GetGems', 6, 1, 0),
	(589, 'GEO', 'GeoCoin', 6, 1, 0),
	(590, 'GIAR', 'GIAR', 6, 1, 0),
	(591, 'GLB', 'Globe', 6, 1, 0),
	(593, 'GML', 'Game League Coin', 6, 1, 0),
	(784, 'GNO', 'Gnosis', 6, 1, 0),
	(594, 'GNS', 'Gnosis', 6, 1, 0),
	(73, 'GNT', 'Golem', 6, 1, 0),
	(595, 'GOLD', 'Crypto-Gold', 6, 1, 0),
	(596, 'GPC', 'GROUPCoin', 6, 1, 0),
	(597, 'GPUC', 'GPUCoin', 6, 1, 0),
	(757, 'GRC', 'GridCoin', 6, 1, 0),
	(598, 'GRCX', 'Gridcoin Classic', 6, 1, 0),
	(599, 'GRS', 'GroestlCoin', 6, 1, 0),
	(600, 'GUE', 'GUE', 6, 1, 0),
	(601, 'H2O', 'Hidrominer', 6, 1, 0),
	(602, 'HIRO', 'HIRO', 6, 1, 0),
	(603, 'HOT', 'HOT', 6, 1, 0),
	(604, 'HUC', 'HUC', 6, 1, 0),
	(756, 'HUGE', 'CryptoHuge', 6, 1, 0),
	(605, 'HVC', 'HVC', 6, 1, 0),
	(606, 'HYP', 'HYP', 6, 1, 0),
	(607, 'HZ', 'HZ', 6, 1, 0),
	(608, 'IFC', 'IFC', 6, 1, 0),
	(759, 'INDEX', 'INDEX', 6, 1, 0),
	(758, 'IOC', 'I/O Coin', 6, 1, 0),
	(609, 'ITC', 'ITC', 6, 1, 0),
	(610, 'IXC', 'IXC', 6, 1, 0),
	(611, 'JLH', 'JLH', 6, 1, 0),
	(612, 'JPC', 'JPC', 6, 1, 0),
	(613, 'JUG', 'JUG', 6, 1, 0),
	(614, 'KDC', 'KDC', 6, 1, 0),
	(615, 'KEY', 'KEY', 6, 1, 0),
	(794, 'KNC', 'Kyber Network', 6, 1, 0),
	(773, 'LBC', 'LBRY Credits', 6, 1, 0),
	(616, 'LC', 'LC', 6, 1, 0),
	(617, 'LCL', 'LCL', 6, 1, 0),
	(618, 'LEAF', 'LEAF', 6, 1, 0),
	(619, 'LGC', 'LGC', 6, 1, 0),
	(620, 'LOL', 'LOL', 6, 1, 0),
	(796, 'LOOM', 'LOOM Networks', 6, 1, 0),
	(621, 'LOVE', 'LOVE', 6, 1, 0),
	(805, 'LPT', 'Livepeer', 6, 1, 0),
	(622, 'LQD', 'LQD', 6, 1, 0),
	(35, 'LSK', 'Lisk', 6, 1, 0),
	(623, 'LTBC', 'LTBC', 6, 1, 0),
	(5, 'LTC', 'Litecoin', 6, 1, 0),
	(625, 'LTCX', 'LTCX', 6, 1, 0),
	(626, 'MAID', 'MaidSafeCoin', 6, 1, 0),
	(799, 'MANA', 'Decentraland', 6, 1, 0),
	(627, 'MAST', 'MAST', 6, 1, 0),
	(628, 'MAX', 'MAX', 6, 1, 0),
	(629, 'MCN', 'MCN', 6, 1, 0),
	(630, 'MEC', 'MEC', 6, 1, 0),
	(631, 'METH', 'METH', 6, 1, 0),
	(632, 'MIL', 'MIL', 6, 1, 0),
	(633, 'MIN', 'MIN', 6, 1, 0),
	(634, 'MINT', 'MINT', 6, 1, 0),
	(635, 'MMC', 'MMC', 6, 1, 0),
	(636, 'MMNXT', 'MMNXT', 6, 1, 0),
	(637, 'MMXIV', 'MMXIV', 6, 1, 0),
	(638, 'MNTA', 'MNTA', 6, 1, 0),
	(639, 'MON', 'MON', 6, 1, 0),
	(640, 'MRC', 'MRC', 6, 1, 0),
	(641, 'MRS', 'MRS', 6, 1, 0),
	(643, 'MTS', 'MTS', 6, 1, 0),
	(644, 'MUN', 'MUN', 6, 1, 0),
	(645, 'MYR', 'MYR', 6, 1, 0),
	(646, 'MZC', 'MZC', 6, 1, 0),
	(647, 'N5X', 'N5X', 6, 1, 0),
	(648, 'NAS', 'NAS', 6, 1, 0),
	(649, 'NAUT', 'NAUT', 6, 1, 0),
	(650, 'NAV', 'NAV', 6, 1, 0),
	(651, 'NBT', 'NBT', 6, 1, 0),
	(652, 'NEOS', 'NEOS', 6, 1, 0),
	(653, 'NL', 'NL', 6, 1, 0),
	(654, 'NMC', 'NMC', 6, 1, 0),
	(803, 'NMR', 'Numerate', 6, 1, 0),
	(655, 'NOBL', 'NOBL', 6, 1, 0),
	(656, 'NOTE', 'NOTE', 6, 1, 0),
	(657, 'NOXT', 'NOXT', 6, 1, 0),
	(658, 'NRS', 'NRS', 6, 1, 0),
	(659, 'NSR', 'NSR', 6, 1, 0),
	(660, 'NTX', 'NTX', 6, 1, 0),
	(781, 'NXC', 'Nexium', 6, 1, 0),
	(661, 'NXT', 'NXT Coin', 6, 1, 0),
	(662, 'NXTI', 'NXTI', 6, 1, 0),
	(788, 'OMG', 'OmiseGO', 6, 1, 0),
	(642, 'OMNI', 'OMNI', 6, 1, 0),
	(663, 'OPAL', 'OPAL', 6, 1, 0),
	(664, 'PAND', 'PAND', 6, 1, 0),
	(782, 'PASC', 'Pascal Coin', 6, 1, 0),
	(665, 'PAWN', 'PAWN', 6, 1, 0),
	(666, 'PIGGY', 'PIGGY', 6, 1, 0),
	(667, 'PINK', 'PINK', 6, 1, 0),
	(668, 'PLX', 'PLX', 6, 1, 0),
	(669, 'PMC', 'PMC', 6, 1, 0),
	(804, 'POLY', 'PolyMath', 6, 1, 0),
	(670, 'POT', 'POT', 6, 1, 0),
	(671, 'PPC', 'PPC', 6, 1, 0),
	(672, 'PRC', 'PRC', 6, 1, 0),
	(673, 'PRT', 'PRT', 6, 1, 0),
	(674, 'PTS', 'PTS', 6, 1, 0),
	(675, 'Q2C', 'Q2C', 6, 1, 0),
	(676, 'QBK', 'QBK', 6, 1, 0),
	(677, 'QCN', 'QCN', 6, 1, 0),
	(678, 'QORA', 'QORA', 6, 1, 0),
	(679, 'QTL', 'QTL', 6, 1, 0),
	(34, 'QTUM', 'Qtum', 6, 1, 0),
	(767, 'RADS', 'Radium', 6, 1, 0),
	(680, 'RBY', 'RBY', 6, 1, 0),
	(94, 'RDD', 'ReddCoin', 6, 1, 0),
	(29, 'REP', 'Augur', 6, 1, 0),
	(682, 'RIC', 'RIC', 6, 1, 0),
	(683, 'RZR', 'RZR', 6, 1, 0),
	(775, 'SBD', 'Steem Dollars', 6, 1, 0),
	(761, 'SC', 'Siacoin', 6, 1, 0),
	(684, 'SDC', 'SDC', 6, 1, 0),
	(685, 'SHIBE', 'SHIBE', 6, 1, 0),
	(686, 'SHOPX', 'SHOPX', 6, 1, 0),
	(687, 'SILK', 'SILK', 6, 1, 0),
	(688, 'SJCX', 'SJCX', 6, 1, 0),
	(689, 'SLR', 'SLR', 6, 1, 0),
	(690, 'SMC', 'SMC', 6, 1, 0),
	(67, 'SNT', 'Status', 6, 1, 0),
	(691, 'SOC', 'SOC', 6, 1, 0),
	(692, 'SPA', 'SPA', 6, 1, 0),
	(693, 'SQL', 'SQL', 6, 1, 0),
	(694, 'SRCC', 'SRCC', 6, 1, 0),
	(695, 'SRG', 'SRG', 6, 1, 0),
	(696, 'SSD', 'SSD', 6, 1, 0),
	(774, 'STEEM', 'Steem', 6, 1, 0),
	(790, 'STORJ', 'Decentralized Cloud Storage', 6, 1, 0),
	(697, 'STR', 'STR', 6, 1, 0),
	(64, 'STRAT', 'Stratis', 6, 1, 0),
	(698, 'SUM', 'SUM', 6, 1, 0),
	(699, 'SUN', 'SUN', 6, 1, 0),
	(700, 'SWARM', 'SWARM', 6, 1, 0),
	(701, 'SXC', 'SXC', 6, 1, 0),
	(703, 'SYS', 'SysCoin', 6, 1, 0),
	(704, 'TAC', 'TalkCoin', 6, 1, 0),
	(705, 'TOR', 'TORCoin', 6, 1, 0),
	(706, 'TRUST', 'Crypto Trust Network', 6, 1, 0),
	(707, 'TWE', 'TWE', 6, 1, 0),
	(708, 'UIS', 'Unitus', 6, 1, 0),
	(709, 'ULTC', 'Umbrella-LTC', 6, 1, 0),
	(710, 'UNITY', 'SuperNET', 6, 1, 0),
	(711, 'URO', 'UroCoin', 6, 1, 0),
	(28, 'USDC', 'USD Coin', 6, 1, 0),
	(712, 'USDE', 'USDe Coin', 6, 1, 0),
	(713, 'USDT', 'Tether', 6, 1, 0),
	(714, 'UTC', 'UltraCoin', 6, 1, 0),
	(715, 'UTIL', 'UTIL', 6, 1, 0),
	(716, 'UVC', 'UniversityCoin', 6, 1, 0),
	(717, 'VIA', 'Viacoin', 6, 1, 0),
	(718, 'VOOT', 'Crypto VOOT', 6, 1, 0),
	(769, 'VOX', 'Voxels', 6, 1, 0),
	(719, 'VRC', 'VeriCoin', 6, 1, 0),
	(720, 'VTC', 'Vertcoin', 6, 1, 0),
	(721, 'WC', 'WinCoin', 6, 1, 0),
	(722, 'WDC', 'WorldCoin', 6, 1, 0),
	(723, 'WIKI', 'WIKI', 6, 1, 0),
	(724, 'WOLF', 'CryptoWolf', 6, 1, 0),
	(725, 'X13', 'X13 Coin', 6, 1, 0),
	(726, 'XAI', 'Sapience AIFX', 6, 1, 0),
	(727, 'XAP', 'Apollon', 6, 1, 0),
	(728, 'XBC', 'Bitcoin Plus', 6, 1, 0),
	(729, 'XC', 'XCurrency', 6, 1, 0),
	(730, 'XCH', 'ClearingHouse', 6, 1, 0),
	(731, 'XCN', 'Crypton,ite', 6, 1, 0),
	(732, 'XCP', 'CounterParty', 6, 1, 0),
	(733, 'XCR', 'Crypti', 6, 1, 0),
	(734, 'XDN', 'DigitalNote', 6, 1, 0),
	(735, 'XDP', 'DogeParty', 6, 1, 0),
	(19, 'XEM', 'NEM/XEM', 6, 1, 0),
	(736, 'XHC', 'HonorCoin', 6, 1, 0),
	(737, 'XLB', 'LibertyCoin', 6, 1, 0),
	(738, 'XMG', 'Magi', 6, 1, 0),
	(12, 'XMR', 'Monero', 6, 1, 0),
	(740, 'XPB', 'PebbleCoin', 6, 1, 0),
	(741, 'XPM', 'PrimeCoin', 6, 1, 0),
	(3, 'XRP', 'Ripple', 6, 1, 0),
	(743, 'XSI', 'StabilityShares', 6, 1, 0),
	(744, 'XST', 'Stealth', 6, 1, 0),
	(745, 'XSV', 'SilliconValleyCoin', 6, 1, 0),
	(746, 'XUSD', 'CoinoUSD', 6, 1, 0),
	(752, 'XVC', 'VCash', 6, 1, 0),
	(747, 'XXC', 'Creds XXC', 6, 1, 0),
	(748, 'YACC', 'YACCoin', 6, 1, 0),
	(749, 'YANG', 'YangCoin', 6, 1, 0),
	(750, 'YC', 'YellowCoin', 6, 1, 0),
	(751, 'YIN', 'YinCoin', 6, 1, 0),
	(702, 'YNC', 'SYNC', 6, 1, 0),
	(24, 'ZEC', 'ZCash', 6, 1, 0),
	(41, 'ZRX', '0x', 6, 1, 0);
/*!40000 ALTER TABLE `currencies_ctc` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
