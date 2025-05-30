import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:linklocker/core/constants/string_constants.dart';
import 'package:linklocker/core/utils/string_utils.dart';
import 'package:linklocker/features/link/data/models/contact_model.dart';
import 'package:linklocker/features/link/data/models/link_model.dart';
import 'package:linklocker/features/link/data/repository_impl/link_repository_impl.dart';
import 'package:linklocker/features/link/domain/entities/contact_entity.dart';
import 'package:linklocker/features/link/domain/entities/link_entity.dart';
import 'package:linklocker/features/link/domain/usecases/delete_link_usecase.dart';
import 'package:linklocker/features/link/domain/usecases/fetch_link_usecase.dart';

part 'link_view_event.dart';
part 'link_view_state.dart';

class LinkViewBloc extends Bloc<LinkViewEvent, LinkViewState> {
  LinkViewBloc() : super(LinkViewInitial()) {
    on<LinkViewEvent>((event, emit) {});
    on<FetchEvent>(_fetchEvent);
    on<UpdateNavigateEvent>(_updateNavigateEvent);
    on<DeleteLinkEvent>(_deleteLinkEvent);
    on<ContactShareEvent>(_contactShareEvent);
    on<DialerEvent>(_dialerEvent);
    on<QrShareEvent>(_qrShareEvent);
  }

  // fetch link
  Future<void> _fetchEvent(FetchEvent event, Emitter<LinkViewState> emit) async {
    emit(LinkViewLoadingState());
    final LinkRepositoryImpl linkRepository = LinkRepositoryImpl();
    final FetchLinkUseCase fetchLinkUseCase = FetchLinkUseCase(linkRepository: linkRepository);
    final Either<bool, List<Map<String, dynamic>>> response = await fetchLinkUseCase.call(event.linkId);
    response.fold((error) {
      emit(LinkViewLinkNotFoundState());
    }, (links) {
      final LinkEntity linkEntity = LinkModel.fromMap(links[0]).toEntity();
      final List<ContactEntity> contacts = links.map((contact) => ContactModel.fromMap(contact).toEntity()).toList();
      emit(LinkViewLoadedState(linkEntity: linkEntity, contacts: contacts));
    });
  }

  // update
  Future<void> _updateNavigateEvent(UpdateNavigateEvent event, Emitter<LinkViewState> emit) async {
    emit(LinkViewNavigateToUpdateActionState(event.linkId));
  }

  // delete
  Future<void> _deleteLinkEvent(DeleteLinkEvent event, Emitter<LinkViewState> emit) async {
    final LinkRepositoryImpl linkRepository = LinkRepositoryImpl();
    final DeleteLinkUseCase deleteLinkUseCase = DeleteLinkUseCase(linkRepository: linkRepository);
    final bool response = await deleteLinkUseCase.call(event.linkId);
    if (response) {
      emit(LinkViewDeleteSuccessActionState());
    } else {
      emit(LinkViewDeletionFailureActionState("Couldn't delete link."));
    }
  }

  // open dialer
  Future<void> _dialerEvent(DialerEvent event, Emitter<LinkViewState> emit) async {
    final String countryCode = event.contacts[0].country != null && event.contacts[0].country != ''
        ? StringUtils.getCountryCode(event.contacts[0].country!)
        : StringConstants.defaultCountry;
    final String number = event.contacts[0].number != null && event.contacts[0].number != '' ? event.contacts[0].number! : '';
    emit(LinkViewOpenDialerActionState("$countryCode $number"));
  }

  // contact share
  Future<void> _contactShareEvent(ContactShareEvent event, Emitter<LinkViewState> emit) async {
    final String name = event.linkEntity.name != null && event.linkEntity.name != '' ? StringUtils.getCapitalizedWords(event.linkEntity.name!) : '';
    final String countryCode = event.contacts[0].country != null && event.contacts[0].country != ''
        ? StringUtils.getCountryCode(event.contacts[0].country!)
        : StringConstants.defaultCountry;
    final String number = event.contacts[0].number != null && event.contacts[0].number != '' ? event.contacts[0].number! : '';
    final String shareText = "$name, $countryCode $number";
    emit(LinkViewContactShareActionState(shareText));
  }

  // qr share
  Future<void> _qrShareEvent(QrShareEvent event, Emitter<LinkViewState> emit) async {
    emit(LinkViewQrShareActionState(linkEntity: event.linkEntity, contacts: event.contacts));
  }
}
