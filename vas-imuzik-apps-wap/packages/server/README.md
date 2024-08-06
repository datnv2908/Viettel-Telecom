# iMuzik Server

# Mục Lục

- [iMuzik Server](#imuzik-server)
- [Mục Lục](#m%e1%bb%a5c-l%e1%bb%a5c)
- [Môi trường DEV](#m%c3%b4i-tr%c6%b0%e1%bb%9dng-dev)
- [Cấu trúc thư mục](#c%e1%ba%a5u-tr%c3%bac-th%c6%b0-m%e1%bb%a5c)
  - [Cấu trúc tổng thể](#c%e1%ba%a5u-tr%c3%bac-t%e1%bb%95ng-th%e1%bb%83)
  - [Cấu trúc 1 module:](#c%e1%ba%a5u-tr%c3%bac-1-module)
  - [`.module.ts`](#modulets)
  - [`.service.ts`](#servicets)
  - [`.resolver[s].ts`](#resolversts)
  - [`.entity.ts` , `schemas.ts`](#entityts--schemasts)
- [Các pattern chính trong server](#c%c3%a1c-pattern-ch%c3%adnh-trong-server)
  - [Dataloader](#dataloader)
  - [`DataLoaderService`](#dataloaderservice)
  - [`ConnectionPagingService`](#connectionpagingservice)
  - [`TaskEither`](#taskeither)

# Môi trường DEV

1. Chạy db

- Cài `docker`, `docker-compose`

```sh
cd dev-env
./dev.sh up mysql redis
```

2. Chạy server

```sh
yarn
yarn start:dev
```

# Cấu trúc thư mục

## Cấu trúc tổng thể

```
server
├── src
│   ├── api -> helper dùng chung API như phân trang và truy vấn entity bằng globalId
│   ├── infra -> chứa các module cấp hệ thống
│   │   ├── config
│   │   ├── logging
│   │   ├── telecom -> Client gọi WebService, quy tắc số điện thoại
│   │   └── util
│   ├── main.ts -> entrypoint của server
│   └── services -> chứa các nghiệp vụ của hệ thống
│       ├── account -> quản lí account: login, captcha, refresh token...
│       ├── marketing -> quản lí banner, spam, advertisement
│       ├── help-center
│       ├── music -> chứa nghiệp vụ liên quan đến nhạc số: bài hát, ca sỹ, chủ đề...
│       ├── notification -> đăng ký push-notification cho mobile
│       ├── rbt -> quản lí nhạc chờ: gói, nhóm...
│       └── social -> quản lí comment cho các bài nhạc số
└── schema.gql -> file tự sinh ra, chứa tất cả các data có thể lấy được và các hành động có thể thực hiện từ phía client
```

## Cấu trúc 1 module:

Mỗi module có thể chứa các dạng file:

## `.module.ts`

- Khái báo module
- Các depandancy của module (nếu dùng service của module khác): `imports: [ ...]`
- Liệt kệ các entity (DB table) mà module sở hữu. Quy ước: **Mỗi enity chỉ thuộc vể một module, các module khác muốn đọc, ghi entity đó phải gọi qua service của module này**
- Liệt kê các service mà module này định nghĩa (`provides: [...]`)
- Liệt kê các service mà module này cho phép các module khác dùng (`exports: [...]`)

## `.service.ts`

- Nơi chứa nghiệp vụ của module, nếu module nhỏ có thể chỉ có 1 file này, nếu module lớn hơn thì sẽ có nhiều file. Nếu có quá nhiều file service nên cân nhắc tách module.

## `.resolver[s].ts`

- Dạng file này chứa các nghiệp vụ viết theo kiểu GraphQL, khác với controller nhóm logic theo từng endpoint, 'resolver' có thể chi tiết đến từng field
- Các decorator có thể gặp:
  - `@Mutation`: các hành động làm thay đổi data nhu `update`, `write`, `delete`
  - `@Query`: entrypoint cho việc truy xuất data (`read`), từ các query các data liên quan có thể truy xuất với độ sâu nhất định (_bây h đang tối da là 6_). Ví dụ: list 10 chủ đề và mỗi chủ đề lấy 10 bài hát mới nhất và với mỗi bài hát lấy tất cả các bài nhạc chờ. Để tăng hiệu năng server, `DataLoader` thường được dùng cho query (xem ở dưới).
  - `@ResolveField`.
- Tham khảo thêm tại [Nestjs Graphql](https://docs.nestjs.com/graphql/quick-start)

## `.entity.ts` , `schemas.ts`

- Các file này chứa định nghĩa của các ORM mapping với bảng và graphql field
- Các cột sẽ có decorator @Column

# Các pattern chính trong server

## Dataloader

Bài toàn cần giải quyết : 1 + N

Để lấy danh sách các chủ đề cấn 1 round trip đến db, để lấy các bài hát của chủ đề này, resolver của chủ đề có thể dùng query `SELECT ... IN list chu de` nhưng việc này sẽ khiến code lập đi lặp lại rất nhiều và sẽ không tối ưu các nhánh khác của 1 query lớn hoặc các query khác.

Dataloader sẽ giúp giải quyết vần đề này bằng cách batch các id cần lấy và dùng query trên nhưng không bị giới hạn trong 1 query / user.
Mặc định Dataloader sẽ nhóm các query trong 1 tick của JS event loop, trong các case mà rule này chưa đủ hiệu quả có thể cân nhắc thêm Scheduler cho DataLoader: nhóm các query trong 100ms trở lại.

Ngoài ra DataLoader còn hỗ trợ Caching, và đây là phương thức cache chính trong toàn bộ hệ thống. Cache Backend được dùng cho DataLoader bao gồm LruCache (in memory) và Redis. Redis được dùng cho các data có thể thay đổi bỡi end user như: Like, Comment, Thông tin cá nhân.

Tham khảo thêm tại: [https://www.npmjs.com/package/dataloader](https://www.npmjs.com/package/dataloader)

## `DataLoaderService`

Đây là 1 helper xây dựng trên nền DataLoader để phục vụ 2 usecase chính:

- Quản lí các dataloader query bằng cách field khác nhau của 1 entity: VD: slug và id
- Quản lí/cache các list của 1 entity: mỗi list sẽ được lưu dưới dạng list của các ID, ví dụ, List các bài nhạc số trong 1 chủ đề, list các bài nhạc số trong thể loại. hàm chính `cachedPaginatedList`: nhận vào list cache key và 1 hàm query từ repo trả về list các row liên quan + tổng số row.

## `ConnectionPagingService`

Data dạng list trong hệ thống được thể hiện và phân trang theo quy chuẩn của [Relay Connection](https://relay.dev/docs/en/graphql-server-specification.html#connections), `ConnectionPagingService` là 1 helper đứng giữa đóng vai trò chuyển các GraphQL query từ dạng (first, last, before, after) sang (skip, take) để có thể dùng trong query đến DB.

## `TaskEither`

Đây là 1 class trong thư viện [fp-ts](https://gcanti.github.io/fp-ts/) (Funtional programming in Typescript) được dùng nhiều trong module `Account` và module `Rbt`. Mục đích chính của việc sử dụng class này là tăng việc tái sử dụng code trong cách flow phức tạp như rbt để giảm độ dài của code. Ví dụ:

```typescript
copyRingTones = flow(
  this.accountService.requireLogin<{ givenTargetMsisdn: string }>(),
  taskEither.chain(({ givenTargetMsisdn, ...ctx }) => async () => {
    const targetMsisdn = this.phoneNumberService.normalizeMsisdn(givenTargetMsisdn);
    return (await this.phoneNumberService.isViettelPhoneNumberAsync(targetMsisdn))
      ? either.right({ ...ctx, targetMsisdn })
      : either.left(new ReturnError(AUTH_REQUIRE_VIETTEL));
  }),
  taskEither.chain(getExternalStatus(this.externalRbtService)),
  taskEither.chain(requireRegistered),
  taskEither.chain((ctx) => async () => {
    const tones = await this.externalRbtService.getUserTones(ctx.targetMsisdn);
    return either.right(
      (
        await Promise.all(tones.map((tone) => this.musicService.findRbtByToneCode(tone.toneCode)))
      ).filter((t) => t)
    );
  })
);
```

Usecase chính là cho các flow sẽ tiếp tục thực hiện nếu vẫn đang thành công (`right`) và bỏ qua các bước sau nếu bước hiện tại thất bại (`left`).
